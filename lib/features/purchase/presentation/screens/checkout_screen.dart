import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../state/cart_provider.dart';
import '../state/checkout_provider.dart';
import '../widgets/delivery_address_card.dart';
import 'order_confirmation_screen.dart';

/// Assigned to: DISSANAYAKE D. M. S. D.
/// Branch: feature/buyer-purchase
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return ChangeNotifierProvider(
      create: (_) => CheckoutProvider(),
      child: Consumer<CheckoutProvider>(
        builder: (context, checkout, _) {
          return Scaffold(
            appBar: const CustomAppBar(title: 'Checkout'),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Delivery Information',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  CustomTextField(
                    label: 'Shipping Address',
                    hint: 'House/Street, City, Postal Code',
                    controller: _addressController,
                    onChanged: checkout.setAddress,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    label: 'Contact Phone Number',
                    hint: '07XXXXXXXX',
                    keyboardType: TextInputType.phone,
                    controller: _phoneController,
                    onChanged: checkout.setPhone,
                  ),
                  const SizedBox(height: 24),
                  const Text('Payment Method',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  RadioListTile<String>(
                    title: const Text('Cash on Delivery (COD)'),
                    subtitle: const Text('Pay when authentic handicraft arrives at your door'),
                    value: 'COD',
                    groupValue: checkout.paymentMethod,
                    onChanged: (val) => checkout.setPaymentMethod(val!),
                  ),
                  RadioListTile<String>(
                    title: const Text('Direct Bank Transfer (Sri Lanka)'),
                    subtitle: const Text('Transfer to Artisan account & upload slip'),
                    value: 'BANK',
                    groupValue: checkout.paymentMethod,
                    onChanged: (val) => checkout.setPaymentMethod(val!),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Payable',
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
                  const SizedBox(height: 30),
                  CustomButton(
                    text: 'Confirm & Place Order',
                    isLoading: checkout.isProcessing,
                    onPressed: () async {
                      if (_addressController.text.isEmpty || _phoneController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please fill all delivery details')),
                        );
                        return;
                      }

                      final success = await checkout.submitOrder(
                        buyerId: 'sample_buyer_id',
                        buyerName: 'Valued Customer',
                        items: cart.cartItems,
                        totalAmountLkr: cart.totalLkr,
                      );

                      if (success && mounted) {
                        final orderId = checkout.placedOrderId ?? 'ORDER123';
                        cart.clearCart();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OrderConfirmationScreen(orderId: orderId),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
