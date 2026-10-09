import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ProductSuccessDialog extends StatelessWidget {
  final bool isEditing;
  final String productTitle;
  final VoidCallback onDismiss;

  const ProductSuccessDialog({
    super.key,
    required this.isEditing,
    required this.productTitle,
    required this.onDismiss,
  });

  static Future<void> show(
    BuildContext context, {
    required bool isEditing,
    required String productTitle,
    required VoidCallback onDismiss,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => ProductSuccessDialog(
        isEditing: isEditing,
        productTitle: productTitle,
        onDismiss: onDismiss,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppColors.accent,
                size: 42,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              isEditing ? 'Craft Listing Updated!' : 'Craft Published Successfully!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isEditing
                  ? '"$productTitle" details and stock levels have been saved.'
                  : '"$productTitle" is now available for customers across Sri Lanka to discover and order.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  onDismiss();
                },
                child: Text(
                  isEditing ? 'Back to Catalogue' : 'View in Catalogue',
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
