import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/shared_models/order_model.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../state/order_tracking_provider.dart';
import '../widgets/order_status_stepper.dart';

/// Assigned to: DISSANAYAKE D. M. S. D.
/// Branch: feature/buyer-purchase
class OrderTrackingScreen extends StatefulWidget {
  final String orderId;

  const OrderTrackingScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrderTrackingProvider()..trackOrder(widget.orderId),
      child: Consumer<OrderTrackingProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            appBar: CustomAppBar(title: 'Track Order #${widget.orderId}'),
            body: provider.isLoading
                ? const LoadingIndicator(message: 'Retrieving order updates...')
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Craft Progress',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 16),
                              OrderStatusStepper(
                                status: provider.currentOrder?.status ?? OrderStatus.pending,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text('Items Ordered',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        if (provider.currentOrder != null)
                          ...provider.currentOrder!.items.map((item) => Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${item.title} x ${item.quantity}',
                                        style: const TextStyle(fontWeight: FontWeight.w500)),
                                    Text(
                                      CurrencyFormatter.formatLKR(
                                          item.unitPriceLkr * item.quantity),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold, color: AppColors.primary),
                                    ),
                                  ],
                                ),
                              )),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}
