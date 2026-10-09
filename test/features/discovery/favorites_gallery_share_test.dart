import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hasthakala/core/shared_models/product_model.dart';
import 'package:hasthakala/features/discovery/presentation/state/favorites_provider.dart';
import 'package:hasthakala/features/discovery/presentation/widgets/favorite_button.dart';
import 'package:hasthakala/features/discovery/presentation/widgets/product_gallery.dart';
import 'package:hasthakala/features/discovery/presentation/widgets/product_share.dart';
import 'package:hasthakala/features/discovery/presentation/screens/favorites_screen.dart';
import 'package:hasthakala/features/discovery/presentation/screens/product_details_screen.dart';
import 'package:hasthakala/features/purchase/presentation/state/cart_provider.dart';

ProductModel get craft => ProductModel(
    id: 'jug',
    artisanId: 'maker',
    artisanName: 'Sunil',
    title: 'Clay Jug',
    description: '',
    priceLkr: 2400,
    category: 'pottery',
    imageUrls: [],
    district: 'Kandy');

Widget app(FavoritesProvider favorites, Widget child) =>
    MultiProvider(providers: [
      ChangeNotifierProvider.value(value: favorites),
      ChangeNotifierProvider(create: (_) => CartProvider()),
    ], child: MaterialApp(home: child));

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('favorites survive provider recreation and remain account-scoped',
      () async {
    final first = FavoritesProvider();
    await first.setAccount('a');
    expect(await first.toggle('jug'), isTrue);
    first.dispose();
    final second = FavoritesProvider();
    addTearDown(second.dispose);
    await second.setAccount('a');
    expect(second.contains('jug'), isTrue);
    await second.setAccount('b');
    expect(second.ids, isEmpty);
    await second.setAccount('a');
    expect(second.contains('jug'), isTrue);
    await second.toggle('jug');
    await second.setAccount('a', reload: true);
    expect(second.ids, isEmpty);
  });

  test('failed writes do not change saved state', () async {
    final prefs = await SharedPreferences.getInstance();
    var fail = false;
    final favorites = FavoritesProvider(preferences: () async {
      if (fail) throw StateError('storage unavailable');
      return prefs;
    });
    addTearDown(favorites.dispose);
    await favorites.setAccount('a');
    fail = true;
    expect(await favorites.toggle('jug'), isFalse);
    expect(favorites.ids, isEmpty);
    expect(favorites.busy, isFalse);
  });

  test('late account load cannot leak another account favorites', () async {
    SharedPreferences.setMockInitialValues({
      'discovery.favorites.a': ['jug']
    });
    final prefs = await SharedPreferences.getInstance();
    final pending = Completer<SharedPreferences>();
    var reads = 0;
    final favorites = FavoritesProvider(
        preferences: () => ++reads == 1 ? pending.future : Future.value(prefs));
    addTearDown(favorites.dispose);
    final old = favorites.setAccount('a');
    await Future<void>.delayed(const Duration(milliseconds: 1));
    await favorites.setAccount('b');
    pending.complete(prefs);
    await old;
    expect(favorites.account, 'b');
    expect(favorites.ids, isEmpty);
  });

  testWidgets('two hearts synchronize and details show saved state',
      (tester) async {
    final favorites = FavoritesProvider();
    await tester.runAsync(() => favorites.setAccount('a'));
    addTearDown(favorites.dispose);
    await tester.pumpWidget(app(
        favorites,
        const Scaffold(
            body: Row(children: [
          FavoriteButton(productId: 'jug'),
          FavoriteButton(productId: 'jug'),
        ]))));
    await tester.tap(find.byTooltip('Save to favorites').first);
    await tester.pumpAndSettle();
    expect(find.byTooltip('Remove from favorites'), findsNWidgets(2));
    await tester
        .pumpWidget(app(favorites, ProductDetailsScreen(product: craft)));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Remove from favorites'), findsOneWidget);
    expect(find.text('No product photos available'), findsOneWidget);
    expect(find.text('No reviews yet'), findsOneWidget);
    expect(find.text('Verified Ancestral Lineage'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('saved list loads current products and removes missing entries',
      (tester) async {
    final favorites = FavoritesProvider();
    await tester.runAsync(() async {
      await favorites.setAccount('a');
      await favorites.toggle('missing');
    });
    addTearDown(favorites.dispose);
    List<String>? requested;
    await tester
        .pumpWidget(app(favorites, FavoritesScreen(loadProducts: (ids) async {
      requested = ids;
      return [];
    })));
    await tester.pumpAndSettle();
    expect(requested, ['missing']);
    expect(find.text('Craft unavailable'), findsOneWidget);
    await tester.tap(find.byTooltip('Remove from favorites'));
    await tester.pumpAndSettle();
    expect(find.text('No saved crafts yet'), findsOneWidget);
  });

  testWidgets('gallery swipes, thumbnails select and zoom opens/closes',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
            body: SizedBox(
                height: 340,
                child: ProductGallery(images: [
                  'https://example.invalid/1.png',
                  'https://example.invalid/2.png'
                ])))));
    await tester.pumpAndSettle();
    expect(find.text('1 / 2'), findsOneWidget);
    await tester.drag(find.byType(PageView), const Offset(-600, 0));
    await tester.pumpAndSettle();
    expect(find.text('2 / 2'), findsOneWidget);
    await tester.tap(find.byTooltip('View photo 1'));
    await tester.pumpAndSettle();
    expect(find.text('1 / 2'), findsOneWidget);
    await tester.tap(find.text('1 / 2'));
    await tester.pumpAndSettle();
    expect(find.byType(InteractiveViewer), findsOneWidget);
    expect(find.text('Photo 1 of 2'), findsOneWidget);
    await tester.tap(find.byTooltip('Close photo'));
    await tester.pumpAndSettle();
    expect(find.byType(InteractiveViewer), findsNothing);
  });

  testWidgets('Share copies actual product text to platform clipboard',
      (tester) async {
    String? copied;
    tester.binding.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
      if (call.method == 'Clipboard.setData')
        copied = (call.arguments as Map)['text'] as String;
      return null;
    });
    addTearDown(() => tester.binding.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null));
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: Builder(
                builder: (context) => TextButton(
                    onPressed: () => showProductShare(context, craft),
                    child: const Text('Share'))))));
    await tester.tap(find.text('Share'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Copy product details'));
    await tester.pumpAndSettle();
    expect(copied, productShareText(craft));
    expect(copied, contains('Product ID: jug'));
    expect(find.text('Product details copied'), findsOneWidget);
  });
}
