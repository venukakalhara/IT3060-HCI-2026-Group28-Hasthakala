import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hasthakala/core/theme/app_theme.dart';
import 'package:hasthakala/core/localization/app_strings.dart';
import 'package:hasthakala/core/shared_models/product_model.dart';
import 'package:hasthakala/core/shared_models/artisan_profile_model.dart';
import 'package:hasthakala/features/discovery/presentation/state/favorites_provider.dart';
import 'package:hasthakala/features/discovery/presentation/state/discovery_provider.dart';
import 'package:hasthakala/features/purchase/presentation/state/cart_provider.dart';
import 'package:hasthakala/features/purchase/presentation/screens/checkout_screen.dart';
import 'package:hasthakala/features/discovery/discovery.dart';

final craft = ProductModel(
    id: 'test-jug',
    artisanId: 'test-maker',
    artisanName: 'Sunil Kariyawasam',
    title: 'Terracotta Heritage Water Jug',
    description: 'Handmade pottery from a local workshop.',
    priceLkr: 2400,
    category: 'pottery',
    imageUrls: [],
    district: 'Kandy',
    materials: 'Terracotta clay',
    stockQuantity: 5);

void main() {
  setUpAll(() async {
    final loader = FontLoader('PlusJakartaSans');
    loader.addFont(rootBundle.load('assets/fonts/PlusJakartaSans-Regular.ttf'));
    loader.addFont(rootBundle.load('assets/fonts/PlusJakartaSans-Bold.ttf'));
    // Optional local script font for visual QA; never redistribute OS fonts.
    final scriptFont = Platform.environment['DISCOVERY_TEST_SCRIPT_FONT'];
    if (scriptFont != null) {
      final fallback = FontLoader('DiscoveryTestScript');
      fallback.addFont(File(scriptFont)
          .readAsBytes()
          .then((bytes) => ByteData.sublistView(bytes)));
      await fallback.load();
    }
    await loader.load();
    final icons = FontLoader('MaterialIcons');
    icons.addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await icons.load();
  });
  final screens = <String, Widget Function()>{
    'home': () => const HomeScreen(),
    'explore': () => SearchScreen(
        search: ({query, category, district, maxPrice}) async => [craft]),
    'search-empty': () => SearchScreen(
        search: ({query, category, district, maxPrice}) async => []),
    'artisan-search': () => SearchScreen(
        search: ({query, category, district, maxPrice}) async => [],
        loadArtisans: () async => [
              ArtisanProfileModel(
                artisanUid: 'test-maker',
                displayName: 'Sunil Kariyawasam',
                craftType: 'pottery',
                location: 'Kandy',
                verified: true,
              )
            ]),
    'details': () => ProductDetailsScreen(product: craft),
    'profile': () => PublicArtisanProfileScreen(
        artisanId: 'test-maker',
        loadProfile: (id) async => ArtisanProfileModel(
            artisanUid: id,
            displayName: 'Sunil Kariyawasam',
            about:
                'Preserving Sri Lankan pottery traditions through handmade craft.',
            craftType: 'pottery',
            location: 'Kandy',
            verified: true),
        loadProducts: (_) async => [craft]),
    'master': () => const MasterArtisanProfileScreen(),
    'catalog': () => const CraftCatalogScreen(),
    'reviews': () => const ArtisanReviewsScreen(),
    'commission': () => const CustomCommissionScreen(),
    'verification': () => const VerifiedLabMatrixScreen(),
    'checkout': () => const CheckoutScreen(),
  };
  for (final language in ['en', 'si', 'ta']) {
    for (final width in [320.0, 390.0, 960.0]) {
      for (final entry in screens.entries) {
        if (width == 960 &&
            !['explore', 'search-empty', 'artisan-search'].contains(entry.key))
          continue;
        if (language != 'en' &&
            ![
              'home',
              'explore',
              'search-empty',
              'artisan-search',
              'details',
              'profile'
            ].contains(entry.key)) continue;
        testWidgets(
            '${entry.key} $language fits ${width.toInt()}px and scrolls',
            (tester) async {
          SharedPreferences.setMockInitialValues({});
          tester.view.physicalSize = Size(width, 844);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          final favorites = FavoritesProvider();
          await tester.runAsync(() => favorites.setAccount('qa'));
          final boundaryKey = GlobalKey();
          await tester.pumpWidget(MultiProvider(
              providers: [
                ChangeNotifierProvider.value(value: favorites),
                ChangeNotifierProvider(
                    create: (_) => DiscoveryProvider(
                        featuredProducts: () => Stream.value([craft]))),
                ChangeNotifierProvider(
                    create: (_) => CartProvider()..addProduct(craft)),
              ],
              child: MaterialApp(
                  locale: Locale(language),
                  supportedLocales: const [
                    Locale('en'),
                    Locale('si'),
                    Locale('ta')
                  ],
                  localizationsDelegates: GlobalMaterialLocalizations.delegates,
                  theme: AppTheme.lightTheme.copyWith(
                    textTheme: AppTheme.lightTheme.textTheme.apply(
                      fontFamilyFallback: const ['DiscoveryTestScript'],
                    ),
                    elevatedButtonTheme: ElevatedButtonThemeData(
                        style: AppTheme.lightTheme.elevatedButtonTheme.style!
                            .copyWith(
                                textStyle: const WidgetStatePropertyAll(
                                    TextStyle(
                                        fontFamily: AppTheme.fontFamily,
                                        fontFamilyFallback: [
                                          'DiscoveryTestScript'
                                        ],
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)))),
                    outlinedButtonTheme: OutlinedButtonThemeData(
                        style: AppTheme.lightTheme.outlinedButtonTheme.style!
                            .copyWith(
                                textStyle: const WidgetStatePropertyAll(
                                    TextStyle(
                                        fontFamily: AppTheme.fontFamily,
                                        fontFamilyFallback: [
                                          'DiscoveryTestScript'
                                        ],
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)))),
                  ),
                  home: RepaintBoundary(
                      key: boundaryKey,
                      child: MediaQuery(
                          data: MediaQueryData(
                              size: Size(width, 844),
                              textScaler:
                                  TextScaler.linear(width == 320 ? 1.2 : 1)),
                          child: entry.value())))));
          await tester.pumpAndSettle();
          if (entry.key == 'artisan-search') {
            await tester.tap(
                find.text(AppStrings.get('discovery_artisans_tab', language)));
            await tester.pumpAndSettle();
          }
          expect(tester.takeException(), isNull);
          if (width >= 390) {
            await tester.runAsync(() async {
              final boundary = boundaryKey.currentContext!.findRenderObject()!
                  as RenderRepaintBoundary;
              final image = await boundary.toImage(pixelRatio: 1);
              final bytes =
                  await image.toByteData(format: ui.ImageByteFormat.png);
              final directory = Directory('.dart_tool/polish_previews')
                ..createSync(recursive: true);
              File('${directory.path}/${entry.key}_${language}${width == 960 ? '_wide' : ''}.png')
                  .writeAsBytesSync(bytes!.buffer.asUint8List());
              image.dispose();
            });
          }
          final scrollables = find.byType(Scrollable);
          if (scrollables.evaluate().isNotEmpty) {
            // The outer screen scroll covers lower sections without tapping actions.
            final vertical = find.byWidgetPredicate((w) =>
                w is Scrollable && w.axisDirection == AxisDirection.down);
            if (vertical.evaluate().isNotEmpty) {
              for (var i = 0; i < 5; i++) {
                await tester.drag(vertical.first, const Offset(0, -500));
                await tester.pumpAndSettle();
                expect(tester.takeException(), isNull);
              }
            }
          }
          await tester.pumpWidget(const SizedBox());
          favorites.dispose();
        });
      }
    }
  }
}
