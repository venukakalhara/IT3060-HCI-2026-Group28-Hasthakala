import 'package:flutter/material.dart';
import '../../core/shared_models/product_model.dart';
import '../../features/account/account.dart';
import '../../features/artisan/artisan.dart';
import '../../features/discovery/discovery.dart';
import '../../features/purchase/purchase.dart';
import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case AppRoutes.search:
        return MaterialPageRoute(builder: (_) => const SearchScreen());

      case AppRoutes.productDetails:
        final product = settings.arguments as ProductModel;
        return MaterialPageRoute(
          builder: (_) => ProductDetailsScreen(product: product),
        );

      case AppRoutes.artisanProfile:
        final artisanId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => PublicArtisanProfileScreen(artisanId: artisanId),
        );

      case AppRoutes.cart:
        return MaterialPageRoute(builder: (_) => const CartScreen());

      case AppRoutes.checkout:
        // Buy Now sends one product, the cart sends nothing
        final buyNow = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => CheckoutScreen(
              buyNow: buyNow is BuyNowRequest ? buyNow : null),
        );

      case AppRoutes.verifiedLabMatrix:
        return MaterialPageRoute(builder: (_) => const VerifiedLabMatrixScreen());

      case AppRoutes.customCommission:
        return MaterialPageRoute(builder: (_) => const CustomCommissionScreen());

      case AppRoutes.craftCatalog:
        return MaterialPageRoute(builder: (_) => const CraftCatalogScreen());

      case AppRoutes.artisanReviews:
        return MaterialPageRoute(builder: (_) => const ArtisanReviewsScreen());

      case AppRoutes.masterArtisanProfile:
        return MaterialPageRoute(builder: (_) => const MasterArtisanProfileScreen());

      case AppRoutes.orderTracking:
        final orderId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => OrderTrackingScreen(orderId: orderId),
        );

      case AppRoutes.buyerChat:
        final orderId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => BuyerChatScreen(orderId: orderId),
        );

      case AppRoutes.artisanDashboard:
        return MaterialPageRoute(builder: (_) => const ArtisanDashboardScreen());

      case AppRoutes.manageProducts:
        final artisanId = settings.arguments as String? ?? 'sample_artisan_id';
        return MaterialPageRoute(
          builder: (_) => ManageProductsScreen(artisanId: artisanId),
        );

      case AppRoutes.addEditProduct:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => AddEditProductScreen(
            artisanId: args?['artisanId'] ?? 'sample_artisan_id',
            productToEdit: args?['product'],
          ),
        );

      case AppRoutes.artisanOrders:
        return MaterialPageRoute(builder: (_) => const ArtisanOrdersScreen());

      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
