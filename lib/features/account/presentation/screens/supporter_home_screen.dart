import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/tr.dart';
import '../state/auth_provider.dart';
import '../widgets/profile_form_parts.dart';

// I13 supporter home - cards open the existing Products / Orders tabs
class SupporterHomeScreen extends StatelessWidget {
  final ValueChanged<int> onOpenTab; // tab : 1 products, 2 orders

  const SupporterHomeScreen({super.key, required this.onOpenTab});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final grant = auth.activeGrant;
    final firstName = (auth.currentUser?.displayName ?? '').split(' ').first;
    if (grant == null) return const SizedBox.shrink();

    return Scaffold(
      // the banner above already keeps clear of the status bar
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          children: [
            Text(context.tr('hello_name', {'name': firstName}),
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
            const SizedBox(height: 14),

            // who they are helping, with the family photo, 
            Container(
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(20),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 110,
                    child: Image.asset('assets/images/family_banner.jpg', fit: BoxFit.cover),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: AppColors.secondaryLight,
                          child: Text(
                            grant.artisanName.isNotEmpty
                                ? grant.artisanName[0].toUpperCase()
                                : 'H',
                            style: const TextStyle(
                                color: AppColors.primaryDark,
                                fontWeight: FontWeight.w700,
                                fontSize: 18),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(context.tr('supporting_label'),
                                  style: const TextStyle(
                                      color: AppColors.secondaryLight,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1)),
                              const SizedBox(height: 2),
                              Text(grant.artisanName,
                                  style: const TextStyle(
                                      color: AppColors.onPrimary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            FormSectionTitle(context.tr('sh_intro')),
            _ActivityCard(
              icon: Icons.inventory_2_outlined,
              title: context.tr('nav_products'),
              subtitle: context.tr('perm_products_sub'),
              allowed: grant.scopes.products,
              onTap: () => onOpenTab(1),
            ),
            _ActivityCard(
              icon: Icons.receipt_long_outlined,
              title: context.tr('nav_orders'),
              subtitle: context.tr('perm_orders_sub'),
              allowed: grant.scopes.orders,
              onTap: () => onOpenTab(2),
            ),
            _ActivityCard(
              icon: Icons.chat_bubble_outline,
              title: context.tr('act_comm'),
              subtitle: context.tr('act_comm_sub'),
              allowed: grant.scopes.communication,
              onTap: () => onOpenTab(2), // chats are opened from an order
            ),
            // shown only so supporters know it exists-never tappable
            _ActivityCard(
              icon: Icons.manage_accounts_outlined,
              title: context.tr('act_account'),
              subtitle: context.tr('perm_owner_only'),
              allowed: false,
              onTap: () {},
              lockedText: context.tr('perm_owner_only'),
            ),
            const SizedBox(height: 6),
            FieldHint(context.tr('sh_note'), icon: Icons.lock_outline_rounded),
          ],
        ),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool allowed;
  final VoidCallback onTap;
  final String? lockedText;

  const _ActivityCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.allowed,
    required this.onTap,
    this.lockedText,
  });

  @override
  Widget build(BuildContext context) {
    final color = allowed ? AppColors.primary : AppColors.textMuted;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: allowed ? AppColors.surface : AppColors.divider,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: allowed ? onTap : null,
          child: Container(
            padding: const EdgeInsets.all(14),
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
                    color: color.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: color, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: allowed ? AppColors.textPrimary : AppColors.textSecondary)),
                      const SizedBox(height: 2),
                      Text(
                        allowed ? subtitle : (lockedText ?? context.tr('not_included')),
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(allowed ? Icons.chevron_right_rounded : Icons.lock_outline_rounded,
                    color: allowed ? AppColors.primary : AppColors.textMuted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
