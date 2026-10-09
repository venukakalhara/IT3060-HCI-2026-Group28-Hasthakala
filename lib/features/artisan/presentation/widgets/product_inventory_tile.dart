import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/shared_models/product_model.dart';
import '../../../../core/utils/currency_formatter.dart';
import 'craft_image_view.dart';

class ProductInventoryTile extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  const ProductInventoryTile({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
    this.onTap,
  });

  Widget _buildStockBadge() {
    if (!product.isAvailable) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.textMuted.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Text(
          'Inactive',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
        ),
      );
    }

    if (product.stockQuantity <= 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Text(
          'Out of Stock',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.error),
        ),
      );
    }

    if (product.stockQuantity <= 3) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.secondary.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          'Low: ${product.stockQuantity} left',
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.secondaryDark),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        'Stock: ${product.stockQuantity}',
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.accent),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: product.imageUrls.isNotEmpty
                      ? CraftImageView(
                          imagePath: product.imageUrls.first,
                          width: 72,
                          height: 72,
                          fit: BoxFit.cover,
                          borderRadius: BorderRadius.circular(12),
                          fallback: const Icon(
                            Icons.brush,
                            color: AppColors.secondary,
                            size: 32,
                          ),
                        )
                      : const Icon(
                          Icons.brush,
                          color: AppColors.secondary,
                          size: 32,
                        ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        CurrencyFormatter.formatLKR(product.priceLkr),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _buildStockBadge(),
                          const SizedBox(width: 6),
                          Text(
                            product.category,
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Edit Listing',
                  icon: const Icon(Icons.edit_outlined, color: AppColors.textSecondary, size: 20),
                  onPressed: onEdit,
                ),
                IconButton(
                  tooltip: 'Delete Listing',
                  icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                  onPressed: onDelete,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
