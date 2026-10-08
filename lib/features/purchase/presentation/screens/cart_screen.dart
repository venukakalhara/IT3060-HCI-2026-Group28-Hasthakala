import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../state/cart_provider.dart';
import '../widgets/cart_item_tile.dart';
import 'checkout_screen.dart';

/// Assigned to: DISSANAYAKE D. M. S. D.
/// Branch: feature/buyer-purchase
class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'My Craft Cart', showBackButton: false),
      body: Consumer<CartProvider>(
        builder: (context, cart, _) {
          if (cart.cartItems.isEmpty) {
            return EmptyStateView(
              icon: Icons.shopping_bag_outlined,
              title: 'Your cart is empty',
              description: 'Explore traditional crafts and add authentic items to your basket.',
              actionButtonText: 'Start Exploring',
              onActionPressed: () => Navigator.pop(context),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cart.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cart.cartItems[index];
                    return CartItemTile(
                      item: item,
                      onQuantityChanged: (newQty) {
                        cart.updateQuantity(item.productId, newQty);
                      },
                      onRemove: () {
                        cart.removeItem(item.productId);
                      },
                    );
                  },
                ),
              ),
              // Cart Summary Sheet
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))
                  ],
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Subtotal', style: TextStyle(color: AppColors.textSecondary)),
                        Text(
                          CurrencyFormatter.formatLKR(cart.subtotalLkr),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Domestic Delivery',
                            style: TextStyle(color: AppColors.textSecondary)),
                        Text(
                          CurrencyFormatter.formatLKR(cart.deliveryFeeLkr),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Amount',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(
                          CurrencyFormatter.formatLKR(cart.totalLkr),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: 'Proceed to Checkout (${cart.totalItemCount} items)',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
