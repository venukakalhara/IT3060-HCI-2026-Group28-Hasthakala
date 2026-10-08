import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/shared_models/order_model.dart';

class OrderStatusBadge extends StatelessWidget {
  final OrderStatus status;
  final bool isCompact;

  const OrderStatusBadge({
    super.key,
    required this.status,
    this.isCompact = false,
  });

  Color _backgroundColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return AppColors.secondary.withValues(alpha: 0.12);
      case OrderStatus.confirmed:
        return AppColors.primaryLight.withValues(alpha: 0.15);
      case OrderStatus.preparing:
        return AppColors.primary.withValues(alpha: 0.12);
      case OrderStatus.shipped:
        return AppColors.secondaryDark.withValues(alpha: 0.12);
      case OrderStatus.delivered:
        return AppColors.accent.withValues(alpha: 0.12);
      case OrderStatus.cancelled:
        return AppColors.error.withValues(alpha: 0.12);
    }
  }

  Color _foregroundColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return AppColors.secondaryDark;
      case OrderStatus.confirmed:
        return AppColors.primary;
      case OrderStatus.preparing:
        return AppColors.primary;
      case OrderStatus.shipped:
        return AppColors.secondaryDark;
      case OrderStatus.delivered:
        return AppColors.accent;
      case OrderStatus.cancelled:
        return AppColors.error;
    }
  }

  IconData _statusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Icons.hourglass_top_outlined;
      case OrderStatus.confirmed:
        return Icons.check_circle_outline;
      case OrderStatus.preparing:
        return Icons.handyman_outlined;
      case OrderStatus.shipped:
        return Icons.local_shipping_outlined;
      case OrderStatus.delivered:
        return Icons.task_alt_outlined;
      case OrderStatus.cancelled:
        return Icons.cancel_outlined;
    }
  }

  String _statusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = _backgroundColor(status);
    final fg = _foregroundColor(status);
    final label = _statusLabel(status);
    final icon = _statusIcon(status);

    if (isCompact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            color: fg,
            fontSize: 10.5,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: fg),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
