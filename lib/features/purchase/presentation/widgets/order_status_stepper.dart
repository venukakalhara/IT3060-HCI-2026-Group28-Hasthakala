import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/shared_models/order_model.dart';

class OrderStatusStepper extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusStepper({Key? key, required this.status}) : super(key: key);

  int get _currentStepIndex {
    switch (status) {
      case OrderStatus.pending:
        return 0;
      case OrderStatus.confirmed:
        return 1;
      case OrderStatus.preparing:
        return 2;
      case OrderStatus.shipped:
        return 3;
      case OrderStatus.delivered:
        return 4;
      case OrderStatus.cancelled:
        return -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (status == OrderStatus.cancelled) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          children: [
            Icon(Icons.cancel, color: AppColors.error),
            SizedBox(width: 8),
            Text(
              'Order Cancelled',
              style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }

    final steps = ['Placed', 'Confirmed', 'Crafting', 'Dispatched', 'Delivered'];

    return Column(
      children: List.generate(steps.length, (index) {
        final isCompleted = index <= _currentStepIndex;
        final isCurrent = index == _currentStepIndex;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isCompleted ? AppColors.primary : AppColors.border,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : Text('${index + 1}',
                            style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  ),
                ),
                if (index < steps.length - 1)
                  Container(
                    width: 2,
                    height: 36,
                    color: index < _currentStepIndex ? AppColors.primary : AppColors.border,
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                steps[index],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                  color: isCompleted ? AppColors.textPrimary : AppColors.textMuted,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
