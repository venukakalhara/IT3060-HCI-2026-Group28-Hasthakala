import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/tr.dart';
import '../../../../core/shared_models/product_model.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../discovery/presentation/state/discovery_provider.dart';
import '../../../discovery/presentation/widgets/product_card.dart';
import '../state/cart_provider.dart';
import '../widgets/cart_item_tile.dart';
import '../widgets/purchase_parts.dart';

/// Assigned to: DISSANAYAKE D. M. S. D.
/// Branch: feature/buyer-purchase
// I06 Cart - hi-fi HF1 (empty) and HF2 (with items).
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('my_cart')),
        centerTitle: true,
      ),
      body: SafeArea(
        child: cart.isLoading && cart.cartItems.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : cart.cartItems.isEmpty
                ? const _EmptyCart()
                : _FilledCart(cart: cart),
      ),
    );
  }
}

class _FilledCart extends StatelessWidget {
  final CartProvider cart;

  const _FilledCart({required this.cart});

  void _remove(BuildContext context, String productId) {
    cart.removeItem(productId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.tr('item_removed')),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            children: [
              Row(
                children: [
                  const Icon(Icons.circle, size: 8, color: AppColors.accent),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      context.tr('pur_items_selected',
                          {'count': '${cart.totalItemCount}'}),
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.textSecondary),
                    ),
                  ),
                  SmallBadge(
                    text: context.tr('pur_direct_from_artisans'),
                    icon: Icons.handshake_outlined,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              for (final item in cart.cartItems)
                CartItemTile(
                  item: item,
                  onQuantityChanged: (qty) =>
                      cart.updateQuantity(item.productId, qty),
                  onRemove: () => _remove(context, item.productId),
                ),
              const SizedBox(height: 4),
              InfoNote(
                icon: Icons.volunteer_activism_outlined,
                title: context.tr('pur_handmade_title'),
                text: context.tr('pur_handmade_text'),
                color: AppColors.primary,
              ),
              const SizedBox(height: 12),
              PurchaseCard(
                child: Column(
                  children: [
                    AmountRow(
                      label: context.tr('pur_items_subtotal'),
                      value: CurrencyFormatter.formatLKR(cart.subtotalLkr),
                    ),
                    AmountRow(
                      label: context.tr('islandwide_delivery'),
                      value: CurrencyFormatter.formatLKR(cart.deliveryFeeLkr),
                      badge: Tooltip(
                        message: context.tr('pur_delivery_once'),
                        triggerMode: TooltipTriggerMode.tap,
                        child: const Icon(Icons.info_outline,
                            size: 16, color: AppColors.textMuted),
                      ),
                    ),
                    AmountRow(
                      label: context.tr('artisan_packaging'),
                      value: context.tr('pur_free'),
                      valueColor: AppColors.accent,
                    ),
                    const Divider(height: 20),
                    AmountRow(
                      label: context.tr('pur_total_due'),
                      value: CurrencyFormatter.formatLKR(cart.totalLkr),
                      bold: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.checkout),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    '${context.tr('proceed_to_checkout')}  •  ${CurrencyFormatter.formatLKR(cart.totalLkr)}',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    // Suggestions come from Member 1's home screen data (read only).
    // Hidden when it isn't loaded or isn't available.
    var picks = const <ProductModel>[];
    try {
      picks = context.watch<DiscoveryProvider>().featuredProducts;
    } on ProviderNotFoundException {
      picks = const [];
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.08),
            ),
            child: const Icon(Icons.shopping_basket_outlined,
                size: 72, color: AppColors.primary),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          context.tr('cart_empty_title'),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(
          context.tr('cart_empty_desc'),
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textSecondary, height: 1.5),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          // the cart is opened on top of the app, so going back to the
          // first screen shows the home tab again
          onPressed: () =>
              Navigator.of(context).popUntil((route) => route.isFirst),
          icon: const Icon(Icons.arrow_forward, size: 18),
          label: Text(context.tr('discover_crafts')),
        ),
        if (picks.isNotEmpty) ...[
          const SizedBox(height: 32),
          Text(
            context.tr('pur_heritage_label'),
            style: const TextStyle(
              fontSize: 11,
              letterSpacing: 1,
              fontWeight: FontWeight.w700,
              color: AppColors.secondaryDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            context.tr('pur_treasures'),
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 290,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: picks.length > 6 ? 6 : picks.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) => SizedBox(
                width: 170,
                child: ProductCard(
                  product: picks[i],
                  onTap: () => Navigator.pushNamed(
                      context, AppRoutes.productDetails,
                      arguments: picks[i]),
                ),
              ),
            ),
          ),
        ],
        const SizedBox(height: 24),
        InfoNote(
          icon: Icons.verified_user_outlined,
          title: context.tr('pur_handmade_title'),
          text: context.tr('pur_handmade_text'),
        ),
      ],
    );
  }
}
