import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// I01 hi-fi "Checking your available access..." (visibility of system status).
/// Shown while the session and contexts are being loaded.
class CheckingAccessScreen extends StatelessWidget {
  const CheckingAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24),
              Text('Checking your available access...',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              SizedBox(height: 24),
              LinearProgressIndicator(
                color: AppColors.primary,
                backgroundColor: AppColors.border,
              ),
              SizedBox(height: 12),
              Text('Verifying your account and loading your workspace.',
                  style: TextStyle(color: AppColors.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}
