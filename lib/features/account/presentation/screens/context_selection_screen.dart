import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/tr.dart';
import '../../../../core/shared_models/support_models.dart';
import '../state/auth_provider.dart';
import '../widgets/profile_avatar_widget.dart';

// I01 Continue as - only when someone has more than one context
class ContextSelectionScreen extends StatefulWidget {
  const ContextSelectionScreen({super.key});

  @override
  State<ContextSelectionScreen> createState() => _ContextSelectionScreenState();
}

class _ContextSelectionScreenState extends State<ContextSelectionScreen> {
  AppContextType? _selected;
  SupportGrantModel? _selectedGrant;

  void _pick(AppContextType type, [SupportGrantModel? grant]) {
    setState(() {
      _selected = type;
      _selectedGrant = grant;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final firstName = (auth.currentUser?.displayName ?? '').split(' ').first;

    final options = <Widget>[
      _ContextCard(
        icon: Icons.shopping_bag_outlined,
        title: context.tr('ctx_buyer'),
        subtitle: context.tr('ctx_buyer_sub'),
        selected: _selected == AppContextType.buyer,
        onTap: () => _pick(AppContextType.buyer),
      ),
      if (auth.hasArtisanProfile)
        _ContextCard(
          icon: Icons.storefront_outlined,
          title: context.tr('ctx_artisan'),
          subtitle: context.tr('ctx_artisan_sub'),
          selected: _selected == AppContextType.artisan,
          onTap: () => _pick(AppContextType.artisan),
        ),
      for (final grant in auth.supportGrants)
        _ContextCard(
          icon: Icons.people_alt_outlined,
          title: context.tr('ctx_supporting', {'name': grant.artisanName}),
          subtitle: context.tr('ctx_supporting_sub'),
          selected: _selected == AppContextType.supporter &&
              _selectedGrant?.artisanId == grant.artisanId,
          onTap: () => _pick(AppContextType.supporter, grant),
        ),
    ];

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
                        // same avatar as the profile screens, so the uploaded photo shows here too
                        Center(
                          child: ProfileAvatarWidget(
                            name: firstName,
                            radius: 34,
                            uid: auth.currentUser?.uid,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(context.tr('continue_as', {'name': firstName}),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        Text(context.tr('continue_as_sub'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppColors.textSecondary)),
                        const SizedBox(height: 28),
                        ...options.expand((w) => [w, const SizedBox(height: 12)]),
                      ],
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _selected == null
                    ? null
                    : () => auth.selectContext(_selected!, grant: _selectedGrant),
                child: Text(context.tr('continue')),
              ),
              TextButton(onPressed: auth.logout, child: Text(context.tr('sign_out'))),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContextCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _ContextCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary.withValues(alpha: 0.08) : AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
              width: selected ? 1.5 : 1,
            ),
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
              Icon(
                selected ? Icons.check_circle : Icons.radio_button_unchecked,
                color: selected ? AppColors.primary : AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
