import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ProductDeleteDialog extends StatelessWidget {
  final String productTitle;
  final VoidCallback onConfirm;
  final bool isDeleting;

  const ProductDeleteDialog({
    super.key,
    required this.productTitle,
    required this.onConfirm,
    this.isDeleting = false,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String productTitle,
    required VoidCallback onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => ProductDeleteDialog(
        productTitle: productTitle,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: AppColors.surface,
      title: const Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Color(0x1FC62828),
            child: Icon(Icons.delete_outline, color: AppColors.error, size: 20),
          ),
          SizedBox(width: 12),
          Text(
            'Delete Craft Listing?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Are you sure you want to permanently delete "$productTitle"?',
            style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          const Text(
            'This action cannot be undone. Customers will no longer find or buy this handcrafted item.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      actions: [
        TextButton(
          onPressed: isDeleting ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: AppColors.onPrimary,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: isDeleting
              ? null
              : () {
                  Navigator.of(context).pop(true);
                  onConfirm();
                },
          child: isDeleting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Text('Delete Listing'),
        ),
      ],
    );
  }
}
