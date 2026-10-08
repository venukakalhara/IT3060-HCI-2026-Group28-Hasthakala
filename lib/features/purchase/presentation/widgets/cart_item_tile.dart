import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/shared_models/order_model.dart';
import '../../../../core/utils/currency_formatter.dart';

class CartItemTile extends StatelessWidget {
  final OrderItemModel item;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemTile({
    Key? key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: item.imageUrl != null
                ? Image.network(item.imageUrl!, fit: BoxFit.cover)
                : const Icon(Icons.brush, color: AppColors.secondary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  CurrencyFormatter.formatLKR(item.unitPriceLkr),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // Quantity controls
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline, size: 20),
                onPressed: () => onQuantityChanged(item.quantity - 1),
              ),
              Text(
                '${item.quantity}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, size: 20),
                onPressed: () => onQuantityChanged(item.quantity + 1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
