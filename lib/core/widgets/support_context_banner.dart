import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../localization/tr.dart';

// "Supporting <artisan>" banner, always visible in supporter mode
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
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
          child: Row(
            children: [
              const Icon(Icons.people_alt_outlined, color: AppColors.onPrimary, size: 20),
              const SizedBox(width: 10),
              // two lines so long names and Sinhala / Tamil text still fit
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('ctx_supporting', {'name': artisanName}),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: AppColors.onPrimary, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      context.tr('signed_in_as', {'name': supporterName}),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: AppColors.onPrimary.withValues(alpha: 0.85), fontSize: 12),
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
