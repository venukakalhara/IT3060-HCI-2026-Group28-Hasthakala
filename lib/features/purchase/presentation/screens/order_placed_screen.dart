import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/tr.dart';
import '../../../../core/shared_models/order_model.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../widgets/order_text.dart';
import '../widgets/purchase_parts.dart';
import 'my_orders_screen.dart';
import 'order_tracking_screen.dart';

/// Assigned to: DISSANAYAKE D. M. S. D.
/// Branch: feature/buyer-purchase
// I07 Order placed (hi-fi HF9)
// two artisans = two orders, so all of them are shown
class OrderPlacedScreen extends StatelessWidget {
  final List<OrderModel> orders;

  const OrderPlacedScreen({super.key, required this.orders});

  void _home(BuildContext context) =>
      Navigator.of(context).popUntil((route) => route.isFirst);

  void _track(BuildContext context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => orders.length == 1
          ? OrderTrackingScreen(orderId: orders.first.id)
          : const MyOrdersScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final total = orders.fold(0.0, (sum, o) => sum + o.totalAmountLkr);
    final cod = orders.isNotEmpty &&
        orders.first.paymentMethod == PaymentMethods.cashOnDelivery;
    final names = orders
        .map((o) => o.artisanName)
        .where((name) => name.isNotEmpty)
        .toSet()
        .join(' & ');
    final title = orders.length == 1
        ? context.tr('pur_placed_one', {'ref': OrderText.ref(orders.first.id)})
        : context.tr('pur_placed_many', {'count': '${orders.length}'});

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _home(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.tr('pur_order_placed_title')),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  children: [
                    const Center(
                      child: StatusCircle(icon: Icons.check, color: AppColors.accent),
                    ),
                    const SizedBox(height: 16),
                    Text(title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Text(
                      context.tr('pur_placed_sub'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: AppColors.secondaryDark,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 20),
                    for (final order in orders)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: PurchaseCard(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              ItemThumb(
                                imageUrl: order.items.isEmpty
                                    ? null
                                    : order.items.first.imageUrl,
                                size: 56,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SmallBadge(
                                      text: context.tr('pur_order_ref',
                                          {'ref': OrderText.ref(order.id)}),
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(OrderText.itemsTitle(context, order.items),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700)),
                                    ArtisanLine(
                                      artisanId: order.artisanId,
                                      fallbackName: order.artisanName,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                CurrencyFormatter.formatLKR(order.totalAmountLkr),
                                style: const TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ),
                    PurchaseCard(
                      child: Column(
                        children: [
                          IconInfoRow(
                            icon: Icons.payments_outlined,
                            label: context.tr('pur_payment_method'),
                            value: cod
                                ? context.tr('pur_cod_due',
                                    {'amount': CurrencyFormatter.formatLKR(total)})
                                : context.tr('pur_bank_next'),
                          ),
                          const Divider(height: 16),
                          IconInfoRow(
                            icon: Icons.local_shipping_outlined,
                            label: context.tr('pur_estimated_delivery'),
                            value: orders.isEmpty
                                ? ''
                                : OrderText.estimate(context, orders.first.createdAt),
                          ),
                          const Divider(height: 16),
                          IconInfoRow(
                            icon: Icons.storefront_outlined,
                            label: context.tr('pur_artisan_notified'),
                            value: context.tr('pur_artisan_notified_text', {
                              'names': names.isEmpty ? context.tr('pur_artisan') : names
                            }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _track(context),
                      icon: const Icon(Icons.receipt_long_outlined, size: 18),
                      label: Text(context.tr('pur_track_order')),
                    ),
                    const SizedBox(height: 6),
                    TextButton.icon(
                      onPressed: () => _home(context),
                      icon: const Icon(Icons.arrow_back, size: 18),
                      label: Text(context.tr('pur_back_home')),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
