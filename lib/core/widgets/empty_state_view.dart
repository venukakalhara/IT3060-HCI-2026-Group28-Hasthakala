import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class EmptyStateView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? actionButtonText;
  final VoidCallback? onActionPressed;

  const EmptyStateView({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    this.actionButtonText,
    this.onActionPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 72, color: AppColors.textMuted.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            if (actionButtonText != null && onActionPressed != null) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onActionPressed,
                child: Text(actionButtonText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
