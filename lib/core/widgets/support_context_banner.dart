import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Persistent "Supporting <artisan>" context (I13 refinement, FR9, NFR3):
/// makes it clear the supporter is acting as THEMSELF on the artisan's behalf.
class SupportContextBanner extends StatelessWidget {
  final String artisanName;
  final String supporterName;

  const SupportContextBanner({
    super.key,
    required this.artisanName,
    required this.supporterName,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.accent,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const Icon(Icons.people_alt_outlined, color: AppColors.onPrimary, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Supporting $artisanName',
                  style: const TextStyle(
                      color: AppColors.onPrimary, fontWeight: FontWeight.w600),
                ),
              ),
              Text('Signed in as $supporterName',
                  style: const TextStyle(color: AppColors.onPrimary, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
