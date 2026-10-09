import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

// full-screen message (account created, all set, check your email...):
// icon, title and text in the middle, buttons at the bottom
class StatusScreen extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String primaryLabel;
  final VoidCallback? onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final bool loading;
  final Widget? extra;
  final Color color;
  // shown instead of the round icon when given (e.g. a profile preview)
  final Widget? header;

  const StatusScreen({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
    this.loading = false,
    this.extra,
    this.color = AppColors.accent,
    this.header,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (header != null)
                          header!
                        else
                          // soft ring around the icon
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color.withValues(alpha: 0.12),
                            ),
                            child: CircleAvatar(
                              radius: 52,
                              backgroundColor: color,
                              child: Icon(icon, size: 52, color: AppColors.onPrimary),
                            ),
                          ),
                        const SizedBox(height: 28),
                        Text(title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 10),
                        Text(message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: AppColors.textSecondary, fontSize: 15, height: 1.5)),
                        if (extra != null) ...[const SizedBox(height: 28), extra!],
                      ],
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: loading ? null : onPrimary,
                child: loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onPrimary))
                    : Text(primaryLabel),
              ),
              if (secondaryLabel != null) ...[
                const SizedBox(height: 10),
                OutlinedButton(onPressed: onSecondary, child: Text(secondaryLabel!)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
