import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/tr.dart';
import '../../../../core/shared_models/user_model.dart';
import '../state/auth_provider.dart';

// I01 "How will you start using HASTHAKALA?" - asked once
class PurposeSelectionScreen extends StatelessWidget {
  const PurposeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(context.tr('purpose_title'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        Text(context.tr('purpose_sub'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppColors.textSecondary)),
                        const SizedBox(height: 28),
                        _PurposeCard(
                          icon: Icons.shopping_bag_outlined,
                          title: context.tr('purpose_shop'),
                          subtitle: context.tr('purpose_shop_sub'),
                          onTap: auth.isLoading ? null : () => auth.choosePurpose(AccountPurpose.shop),
                        ),
                        const SizedBox(height: 14),
                        _PurposeCard(
                          icon: Icons.storefront_outlined,
                          title: context.tr('purpose_sell'),
                          subtitle: context.tr('purpose_sell_sub'),
                          onTap: auth.isLoading ? null : () => auth.choosePurpose(AccountPurpose.sell),
                        ),
                        const SizedBox(height: 24),
                        // three craft photos as a small strip, like the craft grid in the hi-fi
                        const _CraftStrip(),
                        if (auth.isLoading) ...[
                          const SizedBox(height: 20),
                          const Center(child: CircularProgressIndicator()),
                        ],
                        if (auth.errorMessage != null) ...[
                          const SizedBox(height: 12),
                          Text(context.trMessage(auth.errorMessage)!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: AppColors.error)),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              TextButton(onPressed: auth.logout, child: Text(context.tr('sign_out'))),
            ],
          ),
        ),
      ),
    );
  }
}

class _PurposeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _PurposeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: AppColors.primary, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
              ),
              const CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primary,
                child: Icon(Icons.arrow_forward_rounded, size: 18, color: AppColors.onPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CraftStrip extends StatelessWidget {
  const _CraftStrip();

  @override
  Widget build(BuildContext context) {
    const photos = [
      'assets/images/intro_pottery.jpg',
      'assets/images/intro_mask.jpg',
      'assets/images/intro_weaving.jpg',
    ];
    return Row(
      children: [
        for (var i = 0; i < photos.length; i++) ...[
          if (i > 0) const SizedBox(width: 10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.asset(photos[i], fit: BoxFit.cover),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
