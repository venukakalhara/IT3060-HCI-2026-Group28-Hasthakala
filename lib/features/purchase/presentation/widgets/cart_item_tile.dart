import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/tr.dart';
import '../../../../core/shared_models/order_model.dart';
import '../../../../core/utils/currency_formatter.dart';
import 'purchase_parts.dart';

// One cart line (hi-fi HF2): photo, title, artisan, price, - qty + and remove.
class CartItemTile extends StatelessWidget {
  final OrderItemModel item;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemTile({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.productId),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemove(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: AppColors.error, size: 28),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: PurchaseCard(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ItemThumb(imageUrl: item.imageUrl, size: 84),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 15),
                          ),
                        ),
                        InkWell(
                          onTap: onRemove,
                          borderRadius: BorderRadius.circular(20),
                          child: Tooltip(
                            message: context.tr('remove_item'),
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(Icons.close,
                                  size: 18, color: AppColors.textMuted),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    ArtisanLine(artisanId: item.artisanId, showPlace: true),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            CurrencyFormatter.formatLKR(item.unitPriceLkr),
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        _QuantityStepper(
                          quantity: item.quantity,
                          onChanged: onQuantityChanged,
                        ),
                      ],
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

class _QuantityStepper extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;

  const _QuantityStepper({required this.quantity, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _button(context, Icons.remove, 'pur_decrease', quantity - 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text('$quantity',
                style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
          _button(context, Icons.add, 'pur_increase', quantity + 1),
        ],
      ),
    );
  }

  Widget _button(BuildContext context, IconData icon, String tip, int value) {
    return IconButton(
      tooltip: context.tr(tip),
      visualDensity: VisualDensity.compact,
      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      icon: Icon(icon, size: 18, color: AppColors.textPrimary),
      onPressed: () => onChanged(value),
    );
  }
}
