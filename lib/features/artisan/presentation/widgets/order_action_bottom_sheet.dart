import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/shared_models/order_model.dart';
import '../../../../core/utils/currency_formatter.dart';
import 'order_status_badge.dart';

class OrderActionBottomSheet extends StatefulWidget {
  final OrderModel order;
  final Function(OrderStatus newStatus, String? reason) onStatusChanged;

  const OrderActionBottomSheet({
    super.key,
    required this.order,
    required this.onStatusChanged,
  });

  @override
  State<OrderActionBottomSheet> createState() => _OrderActionBottomSheetState();
}

class _OrderActionBottomSheetState extends State<OrderActionBottomSheet> {
  late OrderStatus _selectedStatus;
  final TextEditingController _reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.order.status;
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  String _statusDescription(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Order received from buyer, awaiting artisan acceptance.';
      case OrderStatus.confirmed:
        return 'Craft materials confirmed and workshop queued.';
      case OrderStatus.preparing:
        return 'Handcrafted item is currently being made or packed.';
      case OrderStatus.shipped:
        return 'Dispatched with delivery partner / postal service.';
      case OrderStatus.delivered:
        return 'Craft successfully delivered to buyer.';
      case OrderStatus.cancelled:
        return 'Order cancelled or unable to fulfill.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Manage Order #${widget.order.id.length > 8 ? widget.order.id.substring(0, 8) : widget.order.id}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Total: ${CurrencyFormatter.formatLKR(widget.order.totalAmountLkr)}',
                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                OrderStatusBadge(status: widget.order.status),
              ],
            ),
            const Divider(height: 24),
            const Text(
              'Customer & Shipping Address:',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(
              '${widget.order.recipientName.isNotEmpty ? widget.order.recipientName : widget.order.buyerName} • ${widget.order.contactPhone}',
              style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
            ),
            Text(
              '${widget.order.shippingAddress}${widget.order.city.isNotEmpty ? ', ${widget.order.city}' : ''}${widget.order.district.isNotEmpty ? ', ${widget.order.district}' : ''}',
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            const Text(
              'Update Fulfillment Status:',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: OrderStatus.values.map((status) {
                final isSelected = _selectedStatus == status;
                return ChoiceChip(
                  label: Text(
                    status.name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.onPrimary : AppColors.textPrimary,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: status == OrderStatus.cancelled ? AppColors.error : AppColors.primary,
                  backgroundColor: AppColors.background,
                  side: BorderSide(
                    color: isSelected
                        ? (status == OrderStatus.cancelled ? AppColors.error : AppColors.primary)
                        : AppColors.border,
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedStatus = status);
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            Text(
              _statusDescription(_selectedStatus),
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontStyle: FontStyle.italic),
            ),
            if (_selectedStatus == OrderStatus.cancelled) ...[
              const SizedBox(height: 14),
              TextField(
                controller: _reasonController,
                decoration: const InputDecoration(
                  labelText: 'Reason for cancellation (optional)',
                  hintText: 'e.g. Out of specialized raw materials',
                ),
              ),
            ],
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selectedStatus == widget.order.status
                        ? null
                        : () {
                            widget.onStatusChanged(
                              _selectedStatus,
                              _reasonController.text.trim().isNotEmpty
                                  ? _reasonController.text.trim()
                                  : null,
                            );
                            Navigator.pop(context);
                          },
                    child: const Text('Save Status'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
