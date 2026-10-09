import '../../../../core/localization/tr.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/shared_models/product_model.dart';
import '../../../purchase/presentation/state/cart_provider.dart';

bool addDiscoveryProduct(BuildContext context, ProductModel product,
    {int quantity = 1, bool showSuccess = true}) {
  final added =
      context.read<CartProvider>().addProduct(product, quantity: quantity);
  if (!added || showSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(added
          ? context.tr('discovery_added', {'name': product.title})
          : context.tr('discovery_cart_stock')),
      action: added
          ? SnackBarAction(
              label: context.tr('discovery_view_cart'),
              onPressed: () => Navigator.pushNamed(context, AppRoutes.cart))
          : null,
    ));
  }
  return added;
}

class DiscoveryCartAction extends StatelessWidget {
  const DiscoveryCartAction({super.key});
  @override
  Widget build(BuildContext context) {
    final count =
        context.select<CartProvider, int>((cart) => cart.totalItemCount);
    return IconButton(
      tooltip: context.tr('discovery_cart_count', {'count': '$count'}),
      onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
      icon: Badge(
          isLabelVisible: count > 0,
          label: Text('$count'),
          child: const Icon(Icons.shopping_bag_outlined)),
    );
  }
}
