import 'package:flutter/material.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/tr.dart';
import '../../../../core/shared_models/order_model.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/phone_utils.dart';
import '../../data/datasources/buyer_orders_remote_datasource.dart';
import '../widgets/order_text.dart';
import '../widgets/purchase_parts.dart';

/// Assigned to: DISSANAYAKE D. M. S. D.
/// Branch: feature/buyer-purchase
// I08 Order details (hi-fi HF12 tracking, HF13 order info, HF14 status update)
// updates live when the artisan changes the status (I12)
class OrderTrackingScreen extends StatefulWidget {
  final String orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  late final Stream<OrderModel?> _order =
      BuyerOrdersRemoteDataSource().streamOrder(widget.orderId);
  int _tab = 0; // 0 tracking, 1 order info, 2 delivery
  OrderStatus? _firstSeen;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<OrderModel?>(
      stream: _order,
      builder: (context, snapshot) {
        final order = snapshot.data;
        final title = context.tr('pur_order_ref', {'ref': OrderText.ref(widget.orderId)});
        Widget body;
        if (snapshot.hasError) {
          body = _centerText(context, context.tr('pur_order_load_error'));
        } else if (snapshot.connectionState == ConnectionState.waiting &&
            order == null) {
          body = const Center(child: CircularProgressIndicator());
        } else if (order == null) {
          body = _centerText(context, context.tr('pur_order_missing'));
        } else {
          _firstSeen ??= order.status;
          body = _details(context, order);
        }
        return Scaffold(
          appBar: AppBar(title: Text(title), centerTitle: true),
          body: SafeArea(child: body),
        );
      },
    );
  }

  Widget _centerText(BuildContext context, String text) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textSecondary)),
      ),
    );
  }

  Widget _details(BuildContext context, OrderModel order) {
    // HF14 - banner when the status changes while this screen is open
    final changed = _firstSeen != null && order.status != _firstSeen;
    final lastChange =
        order.statusHistory.isEmpty ? null : order.statusHistory.last;
    final cancelled = order.status == OrderStatus.cancelled;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            children: [
              if (changed && lastChange != null) ...[
                InfoNote(
                  icon: Icons.local_shipping_outlined,
                  title: context.tr('pur_status_update'),
                  text: context.tr('pur_status_now', {
                    'status': OrderText.status(context, order.status),
                    'time': OrderText.dateTime(context, lastChange.at),
                  }),
                ),
                const SizedBox(height: 12),
              ],
              // order number on its own line, status and date under it,
              // so the number isn't squeezed into a thin column
              Text(
                context.tr('pur_order_ref', {'ref': OrderText.ref(order.id)}),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  OrderStatusChip(status: order.status),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      context.tr('pur_placed_on',
                          {'date': OrderText.date(context, order.createdAt, 'd MMM')}),
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textMuted),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              PurchaseCard(
                child: Column(
                  children: [
                    for (var i = 0; i < order.items.length; i++) ...[
                      if (i > 0) const Divider(height: 18),
                      _ItemRow(item: order.items[i], order: order),
                    ],
                    if (!cancelled) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.local_shipping_outlined,
                                size: 18, color: AppColors.secondaryDark),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                context.tr(order.status == OrderStatus.delivered
                                    ? 'pur_delivered'
                                    : 'pur_estimated_delivery'),
                                style: const TextStyle(
                                    color: AppColors.secondaryDark,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(
                              order.status == OrderStatus.delivered
                                  ? OrderText.date(context, order.updatedAt)
                                  : OrderText.estimate(context, order.createdAt),
                              style: const TextStyle(
                                  color: AppColors.secondaryDark,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _Tabs(
                selected: _tab,
                onChanged: (i) => setState(() => _tab = i),
              ),
              const SizedBox(height: 12),
              if (_tab == 0) _Timeline(order: order),
              if (_tab == 1) _OrderInfo(order: order),
              if (_tab == 2) _DeliveryInfo(order: order),
              const SizedBox(height: 12),
              InfoNote(
                icon: Icons.storefront_outlined,
                title: context.tr('pur_artisan_impact_title'),
                text: context.tr('pur_artisan_impact_text'),
                color: AppColors.primary,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            children: [
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(
                    context, AppRoutes.buyerChat,
                    arguments: order.id),
                icon: const Icon(Icons.chat_bubble_outline, size: 18),
                label: Text(context.tr('pur_message_artisan')),
              ),
              if (_tab != 1)
                TextButton.icon(
                  onPressed: () => setState(() => _tab = 1),
                  icon: const Icon(Icons.receipt_outlined, size: 18),
                  label: Text(context.tr('pur_view_order_info')),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ItemRow extends StatelessWidget {
  final OrderItemModel item;
  final OrderModel order;

  const _ItemRow({required this.item, required this.order});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ItemThumb(imageUrl: item.imageUrl, size: 60),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700)),
              ArtisanLine(
                artisanId: order.artisanId,
                fallbackName: order.artisanName,
                showPlace: true,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(CurrencyFormatter.formatLKR(item.lineTotal),
                style: const TextStyle(
                    color: AppColors.primary, fontWeight: FontWeight.w700)),
            Text(context.tr('pur_qty', {'count': '${item.quantity}'}),
                style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
          ],
        ),
      ],
    );
  }
}

// Tracking | Order info | Delivery
class _Tabs extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;

  const _Tabs({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const keys = ['pur_tab_tracking', 'pur_tab_order_info', 'pur_tab_delivery'];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.border.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          for (var i = 0; i < keys.length; i++)
            Expanded(
              child: Semantics(
                selected: i == selected,
                button: true,
                child: InkWell(
                  onTap: () => onChanged(i),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: i == selected ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      context.tr(keys[i]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: i == selected
                            ? AppColors.onPrimary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// HF12 - artisan progress from statusHistory
class _Timeline extends StatelessWidget {
  final OrderModel order;

  const _Timeline({required this.order});

  static const _flow = [
    OrderStatus.pending,
    OrderStatus.confirmed,
    OrderStatus.preparing,
    OrderStatus.shipped,
    OrderStatus.delivered,
  ];

  @override
  Widget build(BuildContext context) {
    final cancelled = order.status == OrderStatus.cancelled;
    final reached = <OrderStatus, DateTime>{};
    for (final change in order.statusHistory) {
      reached[change.status] = change.at;
    }
    final currentIndex = _flow.indexOf(order.status);
    // a cancelled order only shows the steps it reached
    final steps = cancelled
        ? [..._flow.where(reached.containsKey), OrderStatus.cancelled]
        : _flow;

    return PurchaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.timeline, size: 18, color: AppColors.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(context.tr('pur_artisan_track'),
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
              SmallBadge(text: context.tr('pur_live_updates'), icon: Icons.sync),
            ],
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < steps.length; i++)
            _TimelineStep(
              status: steps[i],
              done: cancelled ||
                  (_flow.indexOf(steps[i]) <= currentIndex && currentIndex >= 0),
              current: steps[i] == order.status,
              at: reached[steps[i]] ??
                  (steps[i] == OrderStatus.pending ? order.createdAt : null),
              last: i == steps.length - 1,
              note: steps[i] == OrderStatus.cancelled ? order.cancelReason : null,
            ),
        ],
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final OrderStatus status;
  final bool done;
  final bool current;
  final DateTime? at;
  final bool last;
  final String? note;

  const _TimelineStep({
    required this.status,
    required this.done,
    required this.current,
    required this.at,
    required this.last,
    this.note,
  });

  @override
  Widget build(BuildContext context) {
    final cancelled = status == OrderStatus.cancelled;
    final color = cancelled
        ? AppColors.error
        : (done ? AppColors.accent : AppColors.textMuted);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 28,
            child: Column(
              children: [
                Icon(
                  cancelled
                      ? Icons.cancel
                      : (done ? Icons.check_circle : Icons.radio_button_unchecked),
                  size: 22,
                  color: color,
                ),
                if (!last)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: done ? AppColors.accent : AppColors.border,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          OrderText.status(context, status),
                          style: TextStyle(
                            fontWeight: current ? FontWeight.w800 : FontWeight.w600,
                            color: done || cancelled
                                ? AppColors.textPrimary
                                : AppColors.textMuted,
                          ),
                        ),
                      ),
                      Text(
                        at != null
                            ? OrderText.dateTime(context, at!)
                            : context.tr('pur_not_yet'),
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    (note != null && note!.isNotEmpty)
                        ? note!
                        : context.tr('pur_track_${status.name}'),
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.35,
                      color: done || cancelled
                          ? AppColors.textSecondary
                          : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// HF13 - order specifications and payment summary
class _OrderInfo extends StatelessWidget {
  final OrderModel order;

  const _OrderInfo({required this.order});

  @override
  Widget build(BuildContext context) {
    final paid = order.paymentStatus == PaymentStatuses.paid;
    return Column(
      children: [
        PurchaseCard(
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.receipt_long_outlined,
                      size: 18, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(context.tr('pur_order_specs'),
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  OrderStatusChip(status: order.status),
                ],
              ),
              const SizedBox(height: 8),
              AmountRow(
                  label: context.tr('pur_order_reference'),
                  value: OrderText.ref(order.id)),
              AmountRow(
                  label: context.tr('pur_date_placed'),
                  value: OrderText.dateTime(context, order.createdAt)),
              AmountRow(
                  label: context.tr('pur_payment_method'),
                  value: OrderText.payment(context, order.paymentMethod)),
              AmountRow(
                label: context.tr('pur_payment_status'),
                value: context.tr(paid ? 'pur_paid' : 'pur_not_paid'),
                valueColor: paid ? AppColors.accent : AppColors.secondaryDark,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PurchaseCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.tr('pur_payment_summary'),
                  style: const TextStyle(
                      fontSize: 12,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary)),
              const SizedBox(height: 6),
              AmountRow(
                  label: context.tr('subtotal'),
                  value: CurrencyFormatter.formatLKR(order.subtotal)),
              AmountRow(
                  label: context.tr('pur_courier_delivery'),
                  value: CurrencyFormatter.formatLKR(order.deliveryFee)),
              AmountRow(
                label: context.tr('artisan_packaging'),
                value: context.tr('pur_free'),
                valueColor: AppColors.accent,
              ),
              const Divider(height: 20),
              AmountRow(
                label: context.tr(paid ? 'pur_total_paid' : 'pur_total_to_pay'),
                value: CurrencyFormatter.formatLKR(order.totalAmountLkr),
                bold: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DeliveryInfo extends StatelessWidget {
  final OrderModel order;

  const _DeliveryInfo({required this.order});

  @override
  Widget build(BuildContext context) {
    final place = [order.shippingAddress, order.city, order.district]
        .where((part) => part.trim().isNotEmpty)
        .join(', ');
    return PurchaseCard(
      child: Column(
        children: [
          IconInfoRow(
            icon: Icons.person_outline,
            label: context.tr('pur_recipient'),
            value: order.recipientName.isEmpty ? order.buyerName : order.recipientName,
          ),
          IconInfoRow(
            icon: Icons.phone_outlined,
            label: context.tr('pur_mobile'),
            value: PhoneUtils.display(order.contactPhone),
          ),
          IconInfoRow(
            icon: Icons.place_outlined,
            label: context.tr('pur_deliver_to'),
            value: place,
          ),
          if ((order.deliveryNote ?? '').isNotEmpty)
            IconInfoRow(
              icon: Icons.sticky_note_2_outlined,
              label: context.tr('pur_delivery_notes'),
              value: order.deliveryNote!,
            ),
        ],
      ),
    );
  }
}
