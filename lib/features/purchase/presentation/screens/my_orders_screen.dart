import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/tr.dart';
import '../../../../core/shared_models/order_model.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../account/presentation/state/auth_provider.dart';
import '../../data/datasources/buyer_orders_remote_datasource.dart';
import '../widgets/order_text.dart';
import '../widgets/purchase_parts.dart';
import 'messages_screen.dart';
import 'order_tracking_screen.dart';

/// Assigned to: DISSANAYAKE D. M. S. D.
/// Branch: feature/buyer-purchase
// I08 My Orders (hi-fi HF11) - the buyer's Orders tab
class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  int _tab = 0; // 0 active, 1 completed
  String? _uid;
  Stream<List<OrderModel>>? _orders;

  // only listen again when the account changes
  Stream<List<OrderModel>>? _ordersFor(String? uid) {
    if (uid != _uid) {
      _uid = uid;
      _orders = uid == null
          ? null
          : BuyerOrdersRemoteDataSource().streamBuyerOrders(uid);
    }
    return _orders;
  }

  @override
  Widget build(BuildContext context) {
    final uid = context.watch<AuthProvider>().currentUser?.uid;
    final stream = _ordersFor(uid);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('pur_my_orders')),
        actions: [
          IconButton(
            tooltip: context.tr('pur_messages'),
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const MessagesScreen())),
          ),
        ],
      ),
      body: SafeArea(
        child: stream == null
            ? const SizedBox.shrink()
            : StreamBuilder<List<OrderModel>>(
                stream: stream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return _Message(
                      icon: Icons.wifi_off,
                      text: context.tr('pur_orders_load_error'),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final all = snapshot.data!;
                  final active =
                      all.where((o) => OrderText.isActive(o.status)).toList();
                  final done =
                      all.where((o) => !OrderText.isActive(o.status)).toList();
                  final shown = _tab == 0 ? active : done;

                  return ListView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    children: [
                      Text(
                        context.tr('pur_my_orders_sub'),
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _TabPill(
                            label: context.tr('pur_tab_active',
                                {'count': '${active.length}'}),
                            selected: _tab == 0,
                            onTap: () => setState(() => _tab = 0),
                          ),
                          const SizedBox(width: 8),
                          _TabPill(
                            label: context.tr('pur_tab_completed',
                                {'count': '${done.length}'}),
                            selected: _tab == 1,
                            onTap: () => setState(() => _tab = 1),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      if (shown.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          child: _Message(
                            icon: Icons.receipt_long_outlined,
                            text: context.tr(_tab == 0
                                ? 'pur_no_active_orders'
                                : 'pur_no_completed_orders'),
                          ),
                        )
                      else
                        for (final order in shown)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _OrderCard(order: order),
                          ),
                      const SizedBox(height: 4),
                      InfoNote(
                        icon: Icons.verified_user_outlined,
                        title: context.tr('pur_handmade_title'),
                        text: context.tr('pur_handmade_text'),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}

class _TabPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
                color: selected ? AppColors.primary : AppColors.border),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: selected ? AppColors.onPrimary : AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;

  const _OrderCard({required this.order});

  void _openDetails(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => OrderTrackingScreen(orderId: order.id)));
  }

  @override
  Widget build(BuildContext context) {
    final placedToday = DateUtils.isSameDay(order.createdAt, DateTime.now());
    final cancelled = order.status == OrderStatus.cancelled;

    return InkWell(
      onTap: () => _openDetails(context),
      borderRadius: BorderRadius.circular(16),
      child: PurchaseCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Expanded (not Flexible + Spacer) so the order number gets all
                // the free space and isn't cut to "Order..." in Sinhala / Tamil
                Expanded(
                  child: Text(
                    context.tr('pur_order_ref', {'ref': OrderText.ref(order.id)}),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 8),
                OrderStatusChip(status: order.status),
                const SizedBox(width: 8),
                Text(
                  placedToday
                      ? context.tr('pur_placed_today')
                      : OrderText.date(context, order.createdAt, 'd MMM'),
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ItemThumb(
                  imageUrl: order.items.isEmpty ? null : order.items.first.imageUrl,
                  size: 64,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        OrderText.itemsTitle(context, order.items),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      ArtisanLine(
                        artisanId: order.artisanId,
                        fallbackName: order.artisanName,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        CurrencyFormatter.formatLKR(order.totalAmountLkr),
                        style: const TextStyle(
                            color: AppColors.primary, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (cancelled)
              Text(
                context.tr('pur_cancelled_note'),
                style: const TextStyle(color: AppColors.error, fontSize: 13),
              )
            else
              _MiniProgress(order: order),
            if (!cancelled) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _openDetails(context),
                      icon: const Icon(Icons.map_outlined, size: 18),
                      label: Text(context.tr('pur_track_order')),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => Navigator.pushNamed(
                          context, AppRoutes.buyerChat,
                          arguments: order.id),
                      icon: const Icon(Icons.chat_bubble_outline, size: 18),
                      label: Text(context.tr('pur_chat_artisan')),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Placed - Preparing - Courier - Delivered (hi-fi "Provenance timeline")
class _MiniProgress extends StatelessWidget {
  final OrderModel order;

  const _MiniProgress({required this.order});

  static int stepFor(OrderStatus status) => switch (status) {
        OrderStatus.pending || OrderStatus.confirmed => 0,
        OrderStatus.preparing => 1,
        OrderStatus.shipped => 2,
        _ => 3,
      };

  @override
  Widget build(BuildContext context) {
    final current = stepFor(order.status);
    const labels = [
      'pur_mini_placed',
      'pur_mini_preparing',
      'pur_mini_courier',
      'pur_mini_delivered',
    ];
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  context.tr('pur_progress'),
                  style: const TextStyle(
                      fontSize: 11,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary),
                ),
              ),
              if (order.status != OrderStatus.delivered)
                Text(
                  context.tr('pur_est_short',
                      {'dates': OrderText.estimate(context, order.createdAt)}),
                  style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              for (var i = 0; i < labels.length; i++)
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 2,
                              color: i == 0
                                  ? Colors.transparent
                                  : (i <= current
                                      ? AppColors.accent
                                      : AppColors.border),
                            ),
                          ),
                          Icon(
                            i < current
                                ? Icons.check_circle
                                : (i == current
                                    ? Icons.radio_button_checked
                                    : Icons.circle_outlined),
                            size: 16,
                            color: i < current
                                ? AppColors.accent
                                : (i == current
                                    ? AppColors.secondaryDark
                                    : AppColors.border),
                          ),
                          Expanded(
                            child: Container(
                              height: 2,
                              color: i == labels.length - 1
                                  ? Colors.transparent
                                  : (i < current
                                      ? AppColors.accent
                                      : AppColors.border),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        context.tr(labels[i]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight:
                              i == current ? FontWeight.w700 : FontWeight.w500,
                          color: i == current
                              ? AppColors.secondaryDark
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Message extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Message({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: AppColors.textMuted),
            const SizedBox(height: 12),
            Text(text,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
