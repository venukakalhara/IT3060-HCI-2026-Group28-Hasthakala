import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../localization/tr.dart';

// shown when a supporter opens an area they don't have permission for
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
    // the shell passes English names, shown here in the chosen language
    final feature = context.trMessage(featureName) ?? featureName;
    return Scaffold(
      appBar: AppBar(title: Text(feature)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // same ring as the status screens, in grey because nothing went wrong
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.textSecondary.withValues(alpha: 0.10),
                ),
                child: const CircleAvatar(
                  radius: 44,
                  backgroundColor: AppColors.divider,
                  child: Icon(Icons.lock_outline_rounded, size: 44, color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(height: 24),
              Text(context.tr('restricted_title'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              Text(
                context.tr('restricted_body', {'artisan': artisanName, 'feature': feature}),
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 15, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
