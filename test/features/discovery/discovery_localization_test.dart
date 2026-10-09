import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hasthakala/core/localization/app_strings.dart';
import 'package:hasthakala/core/localization/discovery_strings.dart';
import 'package:hasthakala/features/discovery/presentation/screens/search_screen.dart';
import 'package:hasthakala/features/discovery/presentation/state/search_filter_provider.dart';

void main() {
  test('Discovery translations cover all locales and preserve placeholders',
      () {
    final placeholders = RegExp(r'\{\w+\}');
    for (final entry in discoveryStrings.entries) {
      final expected =
          placeholders.allMatches(entry.value['en']!).map((m) => m[0]).toSet();
      for (final language in ['en', 'si', 'ta']) {
        final text = entry.value[language];
        expect(text, isNotNull, reason: '${entry.key}: $language');
        expect(text!.trim(), isNotEmpty);
        expect(
            placeholders.allMatches(text).map((m) => m[0]).toSet(), expected);
        expect(AppStrings.get(entry.key, language), text);
      }
    }
  });

  for (final language in ['si', 'ta']) {
    testWidgets(
        '$language filters display translated labels and send stable keys',
        (tester) async {
      final categories = <String?>[];
      String t(String key) => AppStrings.get('discovery_$key', language);
      Widget app(String code) => MaterialApp(
            locale: Locale(code),
            supportedLocales: const [Locale('en'), Locale('si'), Locale('ta')],
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            home: SearchScreen(
                search: ({query, category, district, maxPrice}) async {
              categories.add(category);
              return [];
            }),
          );
      await tester.pumpWidget(app(language));
      await tester.pumpAndSettle();
      expect(find.text(t('no_results')), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('discovery-sort')));
      await tester.pumpAndSettle();
      await tester.tap(find.text(t('sort_priceLowToHigh')).last);
      await tester.pumpAndSettle();
      expect(categories.length, 1); // Sorting does not issue another query.
      await tester.tap(find.byTooltip(t('filter_action')));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ChoiceChip, t('category_pottery')));
      await tester.ensureVisible(find.text(t('apply')));
      await tester.tap(find.text(t('apply')));
      await tester.pumpAndSettle();
      expect(categories.last, 'pottery');
      // Rebuild the existing screen after changing the app language.
      await tester.pumpWidget(app('en'));
      await tester.pumpAndSettle();
      expect(find.text('No crafts found'), findsOneWidget);
      expect(find.text(t('no_results')), findsNothing);
      expect(find.text('Clear Filters'), findsOneWidget);
      expect(
          tester
              .widget<DropdownButton<DiscoverySort>>(
                  find.byKey(const ValueKey('discovery-sort')))
              .value,
          DiscoverySort.priceLowToHigh);
      expect(find.text('Price: low to high'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
