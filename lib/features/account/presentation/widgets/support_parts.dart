import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/tr.dart';
import '../../../../core/shared_models/support_models.dart';
import 'profile_cover_header.dart';

// small pieces shared by the I13 screens

// relationship is saved in English, this only changes what is shown
String relationshipName(BuildContext context, String value) {
  const keys = {
    'Family Member': 'rel_family',
    'Son / Daughter': 'rel_child',
    'Spouse': 'rel_spouse',
    'Sibling': 'rel_sibling',
    'Relative': 'rel_relative',
  };
  final key = keys[value];
  return key == null ? value : context.tr(key);
}

// one chip per allowed activity
class ScopeChips extends StatelessWidget {
  final SupportScopes scopes;
  const ScopeChips({super.key, required this.scopes});

  @override
  Widget build(BuildContext context) {
    final items = [
      if (scopes.products) (Icons.inventory_2_outlined, context.tr('nav_products')),
      if (scopes.orders) (Icons.receipt_long_outlined, context.tr('nav_orders')),
      if (scopes.communication) (Icons.chat_bubble_outline, context.tr('scope_messages')),
    ];
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final (icon, label) in items)
          ProfileChip(icon: icon, label: label, color: AppColors.textSecondary),
      ],
    );
  }
}

// green note with a lock, e.g. "Support users can help only in areas you authorize."
class TrustNote extends StatelessWidget {
  final String text;
  const TrustNote(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified_user_outlined, color: AppColors.accent),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text,
                style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

// rounded card with a photo on top and a short centred line under it
class PhotoHeaderCard extends StatelessWidget {
  final String image;
  final String text;
  const PhotoHeaderCard({super.key, required this.image, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 140, child: Image.asset(image, fit: BoxFit.cover)),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
            child: Text(text,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, height: 1.45)),
          ),
        ],
      ),
    );
  }
}
