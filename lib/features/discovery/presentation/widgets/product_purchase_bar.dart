import '../../../../core/localization/tr.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/shared_models/product_model.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../purchase/data/buy_now_request.dart';
import '../../../purchase/presentation/state/cart_provider.dart';
import 'discovery_cart_action.dart';

class ProductPurchaseBar extends StatefulWidget {
  const ProductPurchaseBar({super.key, required this.product});
  final ProductModel product;
  @override
  State<ProductPurchaseBar> createState() => _ProductPurchaseBarState();
}

class _ProductPurchaseBarState extends State<ProductPurchaseBar> {
  int _quantity = 1;
  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final cart = context.watch<CartProvider>();
    final remaining = product.isAvailable
        ? product.stockQuantity - cart.quantityFor(product.id)
        : 0;
    final quantity = remaining > 0 ? _quantity.clamp(1, remaining) : 0;
    final available = remaining > 0;
    return SafeArea(
        child: Container(
      color: AppColors.surface,
      padding: const EdgeInsets.all(12),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(children: [
          Expanded(
              child: Text(
                  available
                      ? CurrencyFormatter.formatLKR(product.priceLkr * quantity)
                      : product.isAvailable && product.stockQuantity > 0
                          ? context.tr('discovery_stock_in_cart')
                          : context.tr('discovery_out_stock'),
                  style: const TextStyle(fontWeight: FontWeight.bold))),
          IconButton(
              tooltip: context.tr('discovery_decrease'),
              onPressed: quantity > 1
                  ? () => setState(() => _quantity = quantity - 1)
                  : null,
              icon: const Icon(Icons.remove)),
          Text('$quantity', key: const ValueKey('purchase-quantity')),
          IconButton(
              tooltip: context.tr('discovery_increase'),
              onPressed: available && quantity < remaining
                  ? () => setState(() => _quantity = quantity + 1)
                  : null,
              icon: const Icon(Icons.add)),
        ]),
        Row(children: [
          Expanded(
              child: OutlinedButton(
                  onPressed: !available
                      ? null
                      : () {
                          if (addDiscoveryProduct(context, product,
                              quantity: quantity))
                            setState(() => _quantity = 1);
                        },
                  child: Text(context.tr('discovery_add_cart')))),
          const SizedBox(width: 12),
          Expanded(
              child: ElevatedButton(
                  onPressed: !available
                      ? null
                      // buy now opens checkout with just this item, cart is not touched
                      : () => Navigator.pushNamed(context, AppRoutes.checkout,
                          arguments:
                              BuyNowRequest(product: product, quantity: quantity)),
                  child: Text(context.tr('discovery_buy_now')))),
        ]),
      ]),
    ));
  }
}
