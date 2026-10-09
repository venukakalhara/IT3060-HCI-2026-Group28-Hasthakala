import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hasthakala/config/routes/app_routes.dart';
import 'package:hasthakala/core/localization/app_strings.dart';
import 'package:hasthakala/core/shared_models/artisan_profile_model.dart';
import 'package:hasthakala/features/discovery/presentation/screens/search_screen.dart';
import 'package:hasthakala/features/discovery/presentation/state/artisan_search_provider.dart';

final makers = [
  ArtisanProfileModel(
      artisanUid: 'maker-a',
      displayName: 'Sunil',
      craftType: 'Pottery & Clay',
      location: 'Kandy',
      verified: true),
  ArtisanProfileModel(
      artisanUid: 'maker-b',
      displayName: 'Nimali',
      craftType: 'pottery',
      location: 'Galle',
      about: 'Traditional clay craft'),
];

void main() {
  test('artisan filters combine without extra reads', () async {
    var reads = 0;
    final provider = ArtisanSearchProvider(load: () async {
      reads++;
      return makers;
    });
    addTearDown(provider.dispose);
    await provider.refresh();
    provider.setCategory('pottery');
    expect(provider.results.length, 2);
    provider.setQuery(' KANDY ');
    expect(provider.results.single.artisanUid, 'maker-a');
    provider.setQuery('clay');
    expect(provider.results.length, 2);
    provider.setVerifiedOnly(true);
    expect(provider.results.single.artisanUid, 'maker-a');
    provider.setCategory('masks');
    expect(provider.results, isEmpty);
    expect(reads, 1);
  });
  test('latest refresh wins, failures retry and disposal ignores responses',
      () async {
    final pending = <Completer<List<ArtisanProfileModel>>>[];
    final provider = ArtisanSearchProvider(load: () {
      final request = Completer<List<ArtisanProfileModel>>();
      pending.add(request);
      return request.future;
    });
    final old = provider.refresh();
    final current = provider.refresh();
    pending[1].complete(makers);
    await current;
    pending[0].complete([]);
    await old;
    expect(provider.results.length, 2);
    final failed = provider.refresh();
    pending[2].completeError(StateError('offline'));
    await failed;
    expect(provider.failed, isTrue);
    final retry = provider.refresh();
    pending[3].complete([]);
    await retry;
    expect(provider.failed, isFalse);
    expect(provider.results, isEmpty);
    final disposed = provider.refresh();
    provider.dispose();
    pending[4].complete(makers);
    await disposed;
  });
  for (final language in ['en', 'si', 'ta']) {
    testWidgets('$language artisan search retries and opens matching profile',
        (tester) async {
      tester.view.physicalSize = const Size(320, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      var fail = true;
      var loads = 0;
      String? openedId;
      final queries = <String?>[];
      String t(String key) => AppStrings.get('discovery_$key', language);
      await tester.pumpWidget(MaterialApp(
        locale: Locale(language),
        supportedLocales: const [Locale('en'), Locale('si'), Locale('ta')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        routes: {
          AppRoutes.artisanProfile: (context) {
            openedId = ModalRoute.of(context)!.settings.arguments as String;
            return const Scaffold(body: Text('Selected profile'));
          }
        },
        home: SearchScreen(
          search: ({query, category, district, maxPrice}) async {
            queries.add(query);
            return [];
          },
          loadArtisans: () async {
            loads++;
            if (fail) throw StateError('offline');
            return makers;
          },
        ),
      ));
      await tester.pumpAndSettle();
      expect(loads, 0);
      await tester.tap(find.text(t('artisans_tab')));
      await tester.pumpAndSettle();
      expect(find.text(t('artisans_error')), findsOneWidget);
      expect(find.byTooltip(t('filter_action')), findsNothing);
      fail = false;
      await tester.tap(find.text(t('retry')));
      await tester.pumpAndSettle();
      expect(find.text('Sunil'), findsOneWidget);
      await tester.tap(find.text(t('verified_only')));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('artisan-maker-b')), findsNothing);
      await tester.tap(find.text(t('verified_only')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Nimali');
      await tester.pumpAndSettle();
      expect(find.text('Sunil'), findsNothing);
      expect(find.byKey(const ValueKey('artisan-maker-b')), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('artisan-maker-b')));
      await tester.pumpAndSettle();
      expect(openedId, 'maker-b');
      Navigator.of(tester.element(find.text('Selected profile'))).pop();
      await tester.pumpAndSettle();
      await tester.tap(find.text(t('products_tab')));
      await tester.pumpAndSettle();
      expect(queries.last, 'Nimali');
      await tester.tap(find.text(t('artisans_tab')));
      await tester.pumpAndSettle();
      expect(loads, 2);
      await tester.enterText(find.byType(TextField), 'missing');
      await tester.pumpAndSettle();
      expect(find.text(t('artisans_empty')), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
