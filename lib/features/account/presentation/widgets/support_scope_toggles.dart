import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/tr.dart';
import '../../../../core/shared_models/support_models.dart';

// permission toggles, used on Add Support User and Support User Details
class SupportScopeToggles extends StatelessWidget {
  final SupportScopes scopes;
  final ValueChanged<SupportScopes>? onChanged; // null = read-only

  const SupportScopeToggles({super.key, required this.scopes, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ToggleRow(
          icon: Icons.inventory_2_outlined,
          title: context.tr('perm_products'),
          subtitle: context.tr('perm_products_sub'),
          value: scopes.products,
          onChanged: onChanged == null
              ? null
              : (v) => onChanged!(scopes.copyWith(products: v)),
        ),
        _ToggleRow(
          icon: Icons.receipt_long_outlined,
          title: context.tr('perm_orders'),
          subtitle: context.tr('perm_orders_sub'),
          value: scopes.orders,
          onChanged: onChanged == null
              ? null
              : (v) => onChanged!(scopes.copyWith(orders: v)),
        ),
        _ToggleRow(
          icon: Icons.chat_bubble_outline,
          title: context.tr('perm_messages'),
          subtitle: context.tr('perm_messages_sub'),
          value: scopes.communication,
          onChanged: onChanged == null
              ? null
              : (v) => onChanged!(scopes.copyWith(communication: v)),
        ),
        // always locked - only the owner can use these
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.divider,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.lock_outline_rounded, color: AppColors.textSecondary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.tr('perm_sensitive'),
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                    const SizedBox(height: 2),
                    Text(context.tr('perm_owner_only'),
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(context.tr('sensitive_note'),
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const _ToggleRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final color = value ? AppColors.accent : AppColors.primary;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          // tapping the card does the same as tapping the switch
          onTap: onChanged == null ? null : () => onChanged!(!value),
          child: Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                  color: value ? AppColors.accent.withValues(alpha: 0.4) : AppColors.border),
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
                      Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                      const SizedBox(height: 2),
                      Text(subtitle, style: const TextStyle(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                Switch(
                  value: value,
                  onChanged: onChanged,
                  activeThumbColor: AppColors.onPrimary,
                  activeTrackColor: AppColors.accent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
