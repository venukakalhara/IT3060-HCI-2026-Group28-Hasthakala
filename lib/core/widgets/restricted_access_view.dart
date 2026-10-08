import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Shown when a supporter opens an area they were not given permission for
/// (I13 low-fi refinement: explicit restricted states; constraints + feedback).
class RestrictedAccessView extends StatelessWidget {
  final String featureName;
  final String artisanName;

  const RestrictedAccessView({
    super.key,
    required this.featureName,
    required this.artisanName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(featureName)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline, size: 48, color: AppColors.textSecondary),
              const SizedBox(height: 12),
              Text('Not part of your support access',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                'Ask $artisanName to allow "$featureName" in Family Assistance if you need it.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
