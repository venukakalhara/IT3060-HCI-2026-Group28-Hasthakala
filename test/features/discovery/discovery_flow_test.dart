import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hasthakala/core/shared_models/product_model.dart';
import 'package:hasthakala/features/discovery/data/discovery_filters.dart';
import 'package:hasthakala/features/discovery/presentation/state/search_filter_provider.dart';
import 'package:hasthakala/features/discovery/presentation/state/discovery_provider.dart';
import 'package:hasthakala/features/discovery/presentation/screens/search_screen.dart';
import 'package:hasthakala/features/discovery/presentation/widgets/search_filter_bottom_sheet.dart';

ProductModel craft(String id,
        {String category = 'Pottery', double price = 2400}) =>
    ProductModel(
      id: id,
      artisanId: 'maker',
      artisanName: 'Sunil',
      title: id,
      description: 'Handmade clay',
      priceLkr: price,
      category: category,
      imageUrls: [],
      district: 'Kandy',
    );

void main() {
  test(
      'price sorting is stable, reversible and does not refetch or mutate source',
      () async {
    final source = [
      craft('high', price: 5000),
      craft('low', price: 1000),
      craft('equal', price: 1000)
    ];
    var calls = 0;
    final provider = SearchFilterProvider(
        search: ({query, category, district, maxPrice}) async {
      calls++;
      return source;
    });
    addTearDown(provider.dispose);
    await provider.performSearch();
    provider.setSort(DiscoverySort.priceLowToHigh);
    expect(provider.searchResults.map((p) => p.id), ['low', 'equal', 'high']);
    provider.setSort(DiscoverySort.priceHighToLow);
    expect(provider.searchResults.map((p) => p.id), ['high', 'low', 'equal']);
    provider.setSort(DiscoverySort.defaultOrder);
    expect(provider.searchResults.map((p) => p.id), ['high', 'low', 'equal']);
    expect(source.first.id, 'high');
    expect(calls, 1);
  });

  test('sort selected while loading persists through filtering and retry',
      () async {
    final pending = Completer<List<ProductModel>>();
    var calls = 0;
    final provider =
        SearchFilterProvider(search: ({query, category, district, maxPrice}) {
      calls++;
      if (calls == 1) return pending.future;
      if (calls == 2) throw StateError('offline');
      return Future.value(
          [craft('high', price: 5000), craft('low', price: 1000)]);
    });
    addTearDown(provider.dispose);
    final request = provider.performSearch(query: 'jug');
    provider.setSort(DiscoverySort.priceLowToHigh);
    pending.complete([craft('high', price: 5000), craft('low', price: 1000)]);
    await request;
    expect(provider.searchResults.first.id, 'low');
    await provider.setCategory('pottery');
    expect(provider.errorMessage, isNotNull);
    await provider.performSearch();
    expect(provider.searchResults.first.id, 'low');
    await provider.clearFilters();
    expect(provider.sort, DiscoverySort.priceLowToHigh);
    expect(provider.query, 'jug');
    expect(provider.searchResults.first.id, 'low');
  });

  test('Home query startup failure exposes retry and retry recovers', () async {
    var fail = true;
    final provider = DiscoveryProvider(featuredProducts: () {
      if (fail) throw StateError('query startup failed');
      return Stream.value([craft('recovered')]);
    });
    addTearDown(provider.dispose);
    await provider.listenToFeaturedProducts();
    expect(provider.isLoading, isFalse);
    expect(provider.errorMessage, isNotNull);
    fail = false;
    await provider.listenToFeaturedProducts();
    expect(provider.errorMessage, isNull);
    expect(provider.featuredProducts.single.id, 'recovered');
  });

  test('Home stream closing without a snapshot ends refresh with an error',
      () async {
    final provider =
        DiscoveryProvider(featuredProducts: () => const Stream.empty());
    addTearDown(provider.dispose);
    await provider.listenToFeaturedProducts();
    expect(provider.isLoading, isFalse);
    expect(provider.errorMessage, isNotNull);
  });

  test('Home empty snapshot is a successful empty catalog', () async {
    final provider =
        DiscoveryProvider(featuredProducts: () => Stream.value([]));
    addTearDown(provider.dispose);
    await provider.listenToFeaturedProducts();
    await Future<void>.delayed(Duration.zero);
    expect(provider.isLoading, isFalse);
    expect(provider.errorMessage, isNull);
    expect(provider.featuredProducts, isEmpty);
  });

  test('Home refresh replaces subscriptions and waits for fresh data',
      () async {
    final streams = <StreamController<List<ProductModel>>>[];
    var cancellations = 0;
    final provider = DiscoveryProvider(featuredProducts: () {
      final controller = StreamController<List<ProductModel>>(onCancel: () {
        cancellations++;
      });
      streams.add(controller);
      return controller.stream;
    });
    final first = provider.listenToFeaturedProducts();
    final second = provider.listenToFeaturedProducts();
    await first;
    expect(cancellations, 1);
    expect(provider.isLoading, isTrue);
    streams.last.add([craft('fresh')]);
    await second;
    expect(provider.featuredProducts.single.id, 'fresh');
    expect(provider.isLoading, isFalse);
    provider.dispose();
    expect(cancellations, 2);
    for (final stream in streams) {
      await stream.close();
    }
  });

  test('Home stream failure ends refresh and exposes retry state', () async {
    final stream = StreamController<List<ProductModel>>();
    final provider = DiscoveryProvider(featuredProducts: () => stream.stream);
    final refresh = provider.listenToFeaturedProducts();
    stream.addError(StateError('offline'));
    await refresh;
    expect(provider.isLoading, isFalse);
    expect(provider.errorMessage, isNotNull);
    expect(provider.featuredProducts, isEmpty);
    provider.dispose();
    await stream.close();
  });

  test(
      'combined filters accept old labels and schema keys with no hidden price cap',
      () {
    final products = [
      craft('jug'),
      craft('expensive jug', category: 'pottery', price: 60000),
      craft('mask', category: 'Traditional Masks')
    ];
    expect(
        filterDiscoveryProducts(products,
                query: ' JUG ', category: 'Pottery & Clay', district: 'kandy')
            .length,
        2);
    expect(
        filterDiscoveryProducts(products,
                query: 'jug', category: 'pottery', maxPrice: 2500)
            .single
            .id,
        'jug');
    expect(
        filterDiscoveryProducts(products, category: 'masks').single.id, 'mask');
    expect(filterDiscoveryProducts(products, query: 'nonexistent'), isEmpty);
    expect(discoveryCategoryKey('Wood Carving'),
        discoveryCategoryKey('Woodcarving'));
  });

  test('Apply and Reset retain query and refresh results', () async {
    final calls = <Map<String, Object?>>[];
    final provider = SearchFilterProvider(
        search: ({query, category, district, maxPrice}) async {
      calls.add({
        'query': query,
        'category': category,
        'district': district,
        'maxPrice': maxPrice
      });
      return [];
    });
    addTearDown(provider.dispose);
    await provider.performSearch(query: 'jug');
    await provider.applyFilters(
        category: 'Pottery', district: 'Kandy', maxPrice: 2500);
    expect(calls.last, {
      'query': 'jug',
      'category': 'pottery',
      'district': 'Kandy',
      'maxPrice': 2500.0
    });
    await provider.clearFilters();
    expect(calls.last,
        {'query': 'jug', 'category': null, 'district': null, 'maxPrice': null});
    expect(provider.hasFilters, isFalse);
  });

  test('older responses cannot overwrite newer results', () async {
    final pending = <Completer<List<ProductModel>>>[];
    final provider =
        SearchFilterProvider(search: ({query, category, district, maxPrice}) {
      final completer = Completer<List<ProductModel>>();
      pending.add(completer);
      return completer.future;
    });
    addTearDown(provider.dispose);
    final old = provider.performSearch(query: 'old');
    final latest = provider.performSearch(query: 'new');
    pending[1].complete([craft('new')]);
    await latest;
    pending[0].complete([craft('old')]);
    await old;
    expect(provider.searchResults.single.id, 'new');
  });

  test('errors are distinguishable from empty results and retry recovers',
      () async {
    var fail = true;
    final provider = SearchFilterProvider(
        search: ({query, category, district, maxPrice}) async {
      if (fail) throw StateError('offline');
      return [];
    });
    addTearDown(provider.dispose);
    await provider.performSearch();
    expect(provider.errorMessage, isNotNull);
    fail = false;
    await provider.performSearch();
    expect(provider.errorMessage, isNull);
    expect(provider.searchResults, isEmpty);
  });

  test('completion after disposal does not notify', () async {
    final pending = Completer<List<ProductModel>>();
    final provider = SearchFilterProvider(
        search: ({query, category, district, maxPrice}) => pending.future);
    final search = provider.performSearch();
    provider.dispose();
    pending.complete([]);
    await search;
  });

  testWidgets('initial load, debounced query and real empty state',
      (tester) async {
    final queries = <String?>[];
    await tester.pumpWidget(MaterialApp(home: SearchScreen(
      search: ({query, category, district, maxPrice}) async {
        queries.add(query);
        return [];
      },
    )));
    await tester.pumpAndSettle();
    expect(queries, ['']);
    expect(find.text('No crafts found'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsNothing);
    await tester.enterText(find.byType(TextField), 'j');
    await tester.pump(const Duration(milliseconds: 100));
    await tester.enterText(find.byType(TextField), 'jug');
    await tester.pump(const Duration(milliseconds: 299));
    expect(queries.length, 1);
    await tester.pumpAndSettle(const Duration(milliseconds: 301));
    expect(queries, ['', 'jug']);
    await tester.tap(find.byTooltip('Clear search'));
    await tester.pumpAndSettle();
    expect(queries.last, '');
  });

  testWidgets('Home-style category entry searches immediately', (tester) async {
    String? selected;
    await tester.pumpWidget(MaterialApp(
        home: SearchScreen(
      initialCategory: 'Woodcarving',
      search: ({query, category, district, maxPrice}) async {
        selected = category;
        return [];
      },
    )));
    await tester.pumpAndSettle();
    expect(selected, 'wood_carving');
    await tester.tap(find.text('Clear Filters'));
    await tester.pumpAndSettle();
    expect(selected, isNull);
  });

  testWidgets(
      'Home-style filter entry opens safely, selection stays draft until Apply',
      (tester) async {
    final calls = <String?>[];
    await tester.pumpWidget(MaterialApp(
        home: SearchScreen(
      openFilters: true,
      search: ({query, category, district, maxPrice}) async {
        calls.add(category);
        return [];
      },
    )));
    await tester.pumpAndSettle();
    expect(find.text('Filter Handicrafts'), findsOneWidget);
    await tester.tap(find.widgetWithText(ChoiceChip, 'Pottery'));
    await tester.pumpAndSettle();
    expect(
        tester
            .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Pottery'))
            .selected,
        isTrue);
    expect(calls, [null]);
    Navigator.of(tester.element(find.byType(SearchFilterBottomSheet))).pop();
    await tester.pumpAndSettle();
    expect(calls, [null]);
    await tester.tap(find.byTooltip('Filter crafts'));
    await tester.pumpAndSettle();
    expect(
        tester
            .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Pottery'))
            .selected,
        isFalse);
    await tester.tap(find.widgetWithText(ChoiceChip, 'Pottery'));
    await tester.ensureVisible(find.text('Apply Filters'));
    await tester.tap(find.text('Apply Filters'));
    await tester.pumpAndSettle();
    expect(calls.last, 'pottery');
    await tester.tap(find.byTooltip('Filter crafts'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();
    expect(calls.last, isNull);
  });

  testWidgets('invalid price cannot apply and retry loads after failure',
      (tester) async {
    var fail = true;
    await tester.pumpWidget(MaterialApp(home: SearchScreen(
      search: ({query, category, district, maxPrice}) async {
        if (fail) throw StateError('offline');
        return [];
      },
    )));
    await tester.pumpAndSettle();
    expect(find.text('Unable to load crafts'), findsOneWidget);
    fail = false;
    await tester.ensureVisible(find.text('Retry'));
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.text('No crafts found'), findsOneWidget);
    await tester.tap(find.byTooltip('Filter crafts'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), '-1');
    await tester.ensureVisible(find.text('Apply Filters'));
    await tester.tap(find.text('Apply Filters'));
    await tester.pumpAndSettle();
    expect(find.text('Enter a valid price of zero or more'), findsOneWidget);
    expect(find.byType(SearchFilterBottomSheet), findsOneWidget);
  });
}
