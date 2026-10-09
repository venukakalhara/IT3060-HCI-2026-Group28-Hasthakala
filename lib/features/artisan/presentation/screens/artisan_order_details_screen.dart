import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/shared_models/order_model.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_time_utils.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../account/presentation/state/auth_provider.dart';
import '../state/artisan_orders_provider.dart';
import '../widgets/craft_image_view.dart';
import '../widgets/order_action_bottom_sheet.dart';
import '../widgets/order_status_badge.dart';
import 'artisan_chat_screen.dart';

class ArtisanOrderDetailsScreen extends StatefulWidget {
  final OrderModel order;

  const ArtisanOrderDetailsScreen({
    super.key,
    required this.order,
  });

  @override
  State<ArtisanOrderDetailsScreen> createState() => _ArtisanOrderDetailsScreenState();
}

class _ArtisanOrderDetailsScreenState extends State<ArtisanOrderDetailsScreen> {
  late OrderModel _currentOrder;

  @override
  void initState() {
    super.initState();
    _currentOrder = widget.order;
  }

  void _openStatusBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => OrderActionBottomSheet(
        order: _currentOrder,
        onStatusChanged: (newStatus, reason) async {
          final auth = context.read<AuthProvider>();
          final ordersProvider = context.read<ArtisanOrdersProvider>();

          final messenger = ScaffoldMessenger.of(context);
          final success = await ordersProvider.changeOrderStatus(
            orderId: _currentOrder.id,
            status: newStatus,
            updatedByUid: auth.currentUser?.uid,
            cancelReason: reason,
          );

          if (!mounted) return;
          if (success) {
            final now = DateTime.now();
            final updatedHistory = List<OrderStatusChange>.from(_currentOrder.statusHistory)
              ..add(OrderStatusChange(status: newStatus, at: now, byUid: auth.currentUser?.uid ?? ''));

            setState(() {
              _currentOrder = OrderModel(
                id: _currentOrder.id,
                buyerId: _currentOrder.buyerId,
                buyerName: _currentOrder.buyerName,
                artisanId: _currentOrder.artisanId,
                artisanName: _currentOrder.artisanName,
                items: _currentOrder.items,
                subtotal: _currentOrder.subtotal,
                deliveryFee: _currentOrder.deliveryFee,
                totalAmountLkr: _currentOrder.totalAmountLkr,
                recipientName: _currentOrder.recipientName,
                shippingAddress: _currentOrder.shippingAddress,
                city: _currentOrder.city,
                district: _currentOrder.district,
                contactPhone: _currentOrder.contactPhone,
                paymentMethod: _currentOrder.paymentMethod,
                paymentStatus: _currentOrder.paymentStatus,
                status: newStatus,
                statusHistory: updatedHistory,
                deliveryNote: _currentOrder.deliveryNote,
                cancelReason: reason ?? _currentOrder.cancelReason,
                updatedBy: auth.currentUser?.uid,
                createdAt: _currentOrder.createdAt,
                updatedAt: now,
              );
            });

            messenger.showSnackBar(
              SnackBar(content: Text('Order status updated to ${newStatus.name.toUpperCase()}')),
            );
          }
        },
      ),
    );
  }

  void _openChatScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ArtisanChatScreen(
          chatId: _currentOrder.id,
          artisanId: _currentOrder.artisanId,
          buyerId: _currentOrder.buyerId,
          buyerName: _currentOrder.buyerName,
          orderId: _currentOrder.id,
          orderTotal: _currentOrder.totalAmountLkr,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final canManageOrders = auth.canManageOrders;
    final canChat = auth.canRespondToCustomers;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Order #${_currentOrder.id.length > 8 ? _currentOrder.id.substring(0, 8) : _currentOrder.id}',
        actions: [
          if (canChat)
            IconButton(
              icon: const Icon(Icons.chat_outlined, color: AppColors.primary),
              tooltip: 'Order Inquiry Chat',
              onPressed: () => _openChatScreen(context),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Header Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Current Fulfillment Status',
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateTimeUtils.formatOrderDate(_currentOrder.createdAt),
                        style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  OrderStatusBadge(status: _currentOrder.status),
                ],
              ),
            ),

            if (_currentOrder.cancelReason != null && _currentOrder.cancelReason!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppColors.error, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Cancellation reason: ${_currentOrder.cancelReason}',
                        style: const TextStyle(color: AppColors.error, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Customer & Delivery Information
            _buildSectionCard(
              title: 'Customer & Delivery Info',
              icon: Icons.person_pin_circle_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _currentOrder.recipientName.isNotEmpty ? _currentOrder.recipientName : _currentOrder.buyerName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      if (_currentOrder.contactPhone.isNotEmpty)
                        InkWell(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: _currentOrder.contactPhone));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Phone number copied to clipboard')),
                            );
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.phone_outlined, size: 14, color: AppColors.primary),
                              const SizedBox(width: 4),
                              Text(
                                _currentOrder.contactPhone,
                                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('Delivery Address:', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  const SizedBox(height: 2),
                  Text(
                    '${_currentOrder.shippingAddress}${_currentOrder.city.isNotEmpty ? ', ${_currentOrder.city}' : ''}${_currentOrder.district.isNotEmpty ? ', ${_currentOrder.district}' : ''}',
                    style: const TextStyle(fontSize: 13.5, color: AppColors.textPrimary, height: 1.3),
                  ),
                  if (_currentOrder.deliveryNote != null && _currentOrder.deliveryNote!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Note: "${_currentOrder.deliveryNote}"',
                      style: const TextStyle(fontSize: 12, color: AppColors.secondaryDark, fontStyle: FontStyle.italic),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Order Items
            _buildSectionCard(
              title: 'Order Items (${_currentOrder.items.length})',
              icon: Icons.inventory_2_outlined,
              child: Column(
                children: [
                  for (final item in _currentOrder.items) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                                ? CraftImageView(
                                    imagePath: item.imageUrl!,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    borderRadius: BorderRadius.circular(8),
                                    fallback: const Icon(Icons.brush, color: AppColors.secondary, size: 24),
                                  )
                                : const Icon(Icons.brush, color: AppColors.secondary, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${CurrencyFormatter.formatLKR(item.unitPriceLkr)} × ${item.quantity}',
                                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            CurrencyFormatter.formatLKR(item.lineTotal),
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                    ),
                    if (item != _currentOrder.items.last) const Divider(height: 12),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Payment & Cost Summary
            _buildSectionCard(
              title: 'Payment & Totals',
              icon: Icons.receipt_long_outlined,
              child: Column(
                children: [
                  _buildSummaryRow('Subtotal', CurrencyFormatter.formatLKR(_currentOrder.subtotal)),
                  const SizedBox(height: 6),
                  _buildSummaryRow(
                    'Delivery Fee',
                    _currentOrder.deliveryFee > 0
                        ? CurrencyFormatter.formatLKR(_currentOrder.deliveryFee)
                        : 'Free Delivery',
                  ),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Amount',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary),
                      ),
                      Text(
                        CurrencyFormatter.formatLKR(_currentOrder.totalAmountLkr),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Payment: ${_currentOrder.paymentMethod == PaymentMethods.cashOnDelivery ? 'Cash on Delivery' : 'Bank Transfer'}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _currentOrder.paymentStatus == PaymentStatuses.paid
                                ? AppColors.accent.withValues(alpha: 0.15)
                                : AppColors.secondary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _currentOrder.paymentStatus.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: _currentOrder.paymentStatus == PaymentStatuses.paid
                                  ? AppColors.accent
                                  : AppColors.secondaryDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Status Timeline
            if (_currentOrder.statusHistory.isNotEmpty) ...[
              _buildSectionCard(
                title: 'Order Status Timeline',
                icon: Icons.timeline_outlined,
                child: Column(
                  children: [
                    for (int i = 0; i < _currentOrder.statusHistory.length; i++) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              if (i < _currentOrder.statusHistory.length - 1)
                                Container(
                                  width: 2,
                                  height: 28,
                                  color: AppColors.primary.withValues(alpha: 0.3),
                                ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _currentOrder.statusHistory[i].status.name.toUpperCase(),
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                Text(
                                  DateTimeUtils.formatOrderDate(_currentOrder.statusHistory[i].at),
                                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Action Buttons
            if (canManageOrders)
              CustomButton(
                text: 'Update Order Fulfillment Status',
                onPressed: () => _openStatusBottomSheet(context),
              ),
            if (canChat) ...[
              const SizedBox(height: 12),
              CustomButton(
                text: 'Message Customer regarding Order',
                isOutlined: true,
                icon: Icons.chat_bubble_outline,
                onPressed: () => _openChatScreen(context),
              ),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
            ],
          ),
          const Divider(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
      ],
    );
  }
}
