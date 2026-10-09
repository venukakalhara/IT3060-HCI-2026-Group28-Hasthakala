import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hasthakala/features/discovery/presentation/screens/custom_commission_screen.dart';
import 'package:hasthakala/features/discovery/presentation/screens/craft_catalog_screen.dart';
import 'package:hasthakala/features/discovery/presentation/widgets/product_card.dart';
import 'package:hasthakala/features/discovery/presentation/state/favorites_provider.dart';
import 'package:hasthakala/features/purchase/presentation/screens/checkout_screen.dart';
import 'package:hasthakala/features/purchase/presentation/state/cart_provider.dart';
import 'package:hasthakala/core/shared_models/product_model.dart';

void main() {
  testWidgets('checkout shows actual items and charges delivery once',
      (tester) async {
    final cart = CartProvider()
      ..addProduct(
          ProductModel(
              id: 'p',
              artisanId: 'a',
              artisanName: 'Maker',
              title: 'Actual Basket',
              description: '',
              priceLkr: 1000,
              category: 'cane',
              imageUrls: [],
              district: 'Galle',
              stockQuantity: 3),
          quantity: 2);
    addTearDown(cart.dispose);
    await tester.pumpWidget(ChangeNotifierProvider.value(
        value: cart, child: const MaterialApp(home: CheckoutScreen())));
    await tester.pumpAndSettle();
    expect(find.text('Actual Basket × 2'), findsOneWidget);
    expect(find.text('Heritage Terracotta Jug'), findsNothing);
    // 2000 for the items + 450 delivery
    expect(find.textContaining('2,450.00'), findsWidgets);
    await tester.tap(find.text('Continue to Delivery Details'));
    await tester.pumpAndSettle();
    expect(find.text('Shipping Address'), findsOneWidget);
  });

  testWidgets(
      'commission validates and copies a draft without claiming submission',
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
    await tester.pumpWidget(const MaterialApp(home: CustomCommissionScreen()));
    await tester.ensureVisible(find.text('Copy Request Draft'));
    await tester.tap(find.text('Copy Request Draft'));
    await tester.pumpAndSettle();
    expect(copied, isNull);
    final fields = find.byType(TextField);
    await tester.ensureVisible(fields.at(0));
    await tester.enterText(fields.at(0), 'Custom pot');
    await tester.ensureVisible(fields.at(1));
    await tester.enterText(fields.at(1), 'A small unglazed pot');
    await tester.ensureVisible(find.text('Copy Request Draft'));
    await tester.tap(find.text('Copy Request Draft'));
    await tester.pumpAndSettle();
    expect(copied, contains('Custom pot'));
    expect(find.textContaining('it has not been submitted.'), findsOneWidget);
  });

  testWidgets('catalog sorting changes product order', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final favorites = FavoritesProvider();
    await tester.runAsync(() => favorites.setAccount('test'));
    addTearDown(favorites.dispose);
    await tester.pumpWidget(ChangeNotifierProvider.value(
        value: favorites,
        child: const MaterialApp(home: CraftCatalogScreen())));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Sort catalog'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Price: low to high'));
    await tester.pumpAndSettle();
    expect(
        tester
            .widget<ProductCard>(find.byType(ProductCard).first)
            .product
            .priceLkr,
        1200);
  });
}
