import 'package:shared_preferences/shared_preferences.dart';
import 'package:hasthakala/features/discovery/presentation/state/favorites_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:hasthakala/config/routes/app_routes.dart';
import 'package:hasthakala/core/shared_models/product_model.dart';
import 'package:hasthakala/core/shared_models/artisan_profile_model.dart';
import 'package:hasthakala/features/purchase/presentation/state/cart_provider.dart';
import 'package:hasthakala/features/purchase/presentation/screens/cart_screen.dart';
import 'package:hasthakala/features/discovery/presentation/widgets/product_card.dart';
import 'package:hasthakala/features/discovery/presentation/widgets/product_purchase_bar.dart';
import 'package:hasthakala/features/discovery/presentation/widgets/discovery_cart_action.dart';
import 'package:hasthakala/features/discovery/presentation/screens/public_artisan_profile_screen.dart';

ProductModel product(
        {String id = 'jug',
        String artisan = 'maker',
        int stock = 3,
        bool available = true}) =>
    ProductModel(
      id: id,
      artisanId: artisan,
      artisanName: 'Maker',
      title: id,
      description: 'Clay jug',
      priceLkr: 2400,
      category: 'pottery',
      imageUrls: [],
      district: 'Kandy',
      stockQuantity: stock,
      isAvailable: available,
    );

Widget app(CartProvider cart, Widget home) => MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: cart),
        ChangeNotifierProvider(
            create: (_) => FavoritesProvider()..setAccount('test'))
      ],
      child: MaterialApp(home: home, routes: {
        AppRoutes.cart: (_) => const CartScreen(),
        AppRoutes.checkout: (_) =>
            const Scaffold(body: Text('Checkout destination')),
      }),
    );

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  test('cart merges additions, enforces stock and retains item identity', () {
    final cart = CartProvider();
    addTearDown(cart.dispose);
    expect(cart.addProduct(product(), quantity: 2), isTrue);
    expect(cart.addProduct(product()), isTrue);
    expect(cart.cartItems.length, 1);
    expect(cart.cartItems.single.artisanId, 'maker');
    expect(cart.totalItemCount, 3);
    expect(cart.subtotalLkr, 7200);
    expect(cart.addProduct(product()), isFalse);
    cart.updateQuantity('jug', 4);
    expect(cart.totalItemCount, 3);
    cart.updateQuantity('jug', 2);
    expect(cart.totalItemCount, 2);
    cart.updateQuantity('jug', 0);
    expect(cart.cartItems, isEmpty);
  });

  test('sold out, unavailable and invalid quantities do not mutate cart', () {
    final cart = CartProvider();
    addTearDown(cart.dispose);
    expect(cart.addProduct(product(stock: 0)), isFalse);
    expect(cart.addProduct(product(available: false)), isFalse);
    expect(cart.addProduct(product(), quantity: 0), isFalse);
    expect(cart.addProduct(product(), quantity: -1), isFalse);
    expect(cart.totalItemCount, 0);
  });

  testWidgets('quick add updates cart badge and opens real cart screen',
      (tester) async {
    final cart = CartProvider();
    addTearDown(cart.dispose);
    await tester.pumpWidget(app(
        cart,
        Scaffold(
          appBar: AppBar(actions: const [DiscoveryCartAction()]),
          body: SizedBox(
              width: 240,
              height: 340,
              child: ProductCard(product: product(), onTap: () {})),
        )));
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(cart.totalItemCount, 1);
    expect(find.byTooltip('Cart (1)'), findsOneWidget);
    await tester.tap(find.byTooltip('Cart (1)'));
    await tester.pumpAndSettle();
    expect(find.text('My Cart'), findsOneWidget);
    expect(find.text('jug'), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
  });

  testWidgets('details quantity and Buy Now hand off selected quantity',
      (tester) async {
    final cart = CartProvider();
    addTearDown(cart.dispose);
    await tester.pumpWidget(app(cart,
        Scaffold(bottomNavigationBar: ProductPurchaseBar(product: product()))));
    await tester.tap(find.byTooltip('Increase quantity'));
    await tester.pump();
    expect(
        tester
            .widget<Text>(find.byKey(const ValueKey('purchase-quantity')))
            .data,
        '2');
    await tester.tap(find.text('Buy Now'));
    await tester.pumpAndSettle();
    // buy now should not add anything to the cart
    expect(cart.totalItemCount, 0);
    expect(find.text('Checkout destination'), findsOneWidget);
  });

  testWidgets('existing cart quantity limits repeated detail adds',
      (tester) async {
    final cart = CartProvider();
    addTearDown(cart.dispose);
    cart.addProduct(product(), quantity: 2);
    await tester.pumpWidget(app(cart,
        Scaffold(bottomNavigationBar: ProductPurchaseBar(product: product()))));
    expect(
        tester
            .widget<IconButton>(find.byWidgetPredicate((widget) =>
                widget is IconButton && widget.tooltip == 'Increase quantity'))
            .onPressed,
        isNull);
    await tester.tap(find.text('Add to Cart'));
    await tester.pumpAndSettle();
    expect(cart.totalItemCount, 3);
    expect(
        tester
            .widget<ElevatedButton>(
                find.widgetWithText(ElevatedButton, 'Buy Now'))
            .onPressed,
        isNull);
  });

  testWidgets('sold-out product disables purchase actions on a narrow screen',
      (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final cart = CartProvider();
    addTearDown(cart.dispose);
    await tester.pumpWidget(app(
        cart,
        Scaffold(
            bottomNavigationBar:
                ProductPurchaseBar(product: product(stock: 0)))));
    expect(find.text('Out of stock'), findsOneWidget);
    expect(
        tester
            .widget<OutlinedButton>(
                find.widgetWithText(OutlinedButton, 'Add to Cart'))
            .onPressed,
        isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'public profile shows requested maker and only their available products',
      (tester) async {
    final cart = CartProvider();
    addTearDown(cart.dispose);
    final requested = <String>[];
    await tester.pumpWidget(app(
        cart,
        PublicArtisanProfileScreen(
          artisanId: 'maker-b',
          loadProfile: (id) async {
            requested.add(id);
            return ArtisanProfileModel(
                artisanUid: id,
                displayName: 'Nimali',
                about: 'Weaving story',
                verified: false);
          },
          loadProducts: (id) async {
            requested.add(id);
            return [
              product(id: 'basket', artisan: id),
              product(id: 'other', artisan: 'maker-a'),
              product(id: 'hidden', artisan: id, available: false)
            ];
          },
        )));
    await tester.pumpAndSettle();
    expect(requested, ['maker-b', 'maker-b']);
    expect(find.text('Nimali'), findsOneWidget);
    expect(find.text('Weaving story'), findsOneWidget);
    expect(find.text('Workshop Masterpieces (1)'), findsOneWidget);
    expect(find.text('Verified artisan'), findsNothing);
    expect(find.text('other'), findsNothing);
  });

  testWidgets('missing artisan does not substitute a sample profile',
      (tester) async {
    final cart = CartProvider();
    addTearDown(cart.dispose);
    var productReads = 0;
    await tester.pumpWidget(app(
        cart,
        PublicArtisanProfileScreen(
          artisanId: 'missing',
          loadProfile: (_) async => null,
          loadProducts: (_) async {
            productReads++;
            return [];
          },
        )));
    await tester.pumpAndSettle();
    expect(find.text('Artisan not found'), findsOneWidget);
    expect(find.text('Sunil Kariyawasam'), findsNothing);
    expect(productReads, 0);
  });

  testWidgets('profile failure retries and verification uses stored flag',
      (tester) async {
    final cart = CartProvider();
    addTearDown(cart.dispose);
    var fail = true;
    await tester.pumpWidget(app(
        cart,
        PublicArtisanProfileScreen(
          artisanId: 'maker',
          loadProfile: (id) async {
            if (fail) throw StateError('offline');
            return ArtisanProfileModel(
                artisanUid: id, displayName: 'Maker', verified: true);
          },
          loadProducts: (_) async => [],
        )));
    await tester.pumpAndSettle();
    expect(find.text('Unable to load artisan'), findsOneWidget);
    fail = false;
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.text('Verified artisan'), findsOneWidget);
    expect(find.text('No crafts listed yet'), findsOneWidget);
  });
}
