import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/shared_models/support_models.dart';
import '../state/auth_provider.dart';

/// I01 hi-fi "Continue as <name>" - shown ONLY when the person has more than
/// one context (decision D1). Supporter contexts appear only from an
/// I13 authorisation, never self-selected.
class ContextSelectionScreen extends StatefulWidget {
  const ContextSelectionScreen({super.key});

  @override
  State<ContextSelectionScreen> createState() => _ContextSelectionScreenState();
}

class _ContextSelectionScreenState extends State<ContextSelectionScreen> {
  AppContextType? _selected;
  SupportGrantModel? _selectedGrant;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final firstName = (auth.currentUser?.displayName ?? '').split(' ').first;

    final options = <Widget>[
      _ContextCard(
        icon: Icons.shopping_bag_outlined,
        title: 'Buyer',
        subtitle: 'Shop for unique handmade crafts from local artisans',
        selected: _selected == AppContextType.buyer,
        onTap: () => setState(() {
          _selected = AppContextType.buyer;
          _selectedGrant = null;
        }),
      ),
      if (auth.hasArtisanProfile)
        _ContextCard(
          icon: Icons.storefront_outlined,
          title: 'Artisan',
          subtitle: 'Manage your crafts, orders and business',
          selected: _selected == AppContextType.artisan,
          onTap: () => setState(() {
            _selected = AppContextType.artisan;
            _selectedGrant = null;
          }),
        ),
      for (final grant in auth.supportGrants)
        _ContextCard(
          icon: Icons.people_alt_outlined,
          title: 'Supporting ${grant.artisanName}',
          subtitle: 'Assist with authorised business activities',
          selected: _selected == AppContextType.supporter &&
              _selectedGrant?.artisanId == grant.artisanId,
          onTap: () => setState(() {
            _selected = AppContextType.supporter;
            _selectedGrant = grant;
          }),
        ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Continue as $firstName',
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text(
                "You have multiple available contexts. Choose how you'd like to continue.",
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              ...options.expand((w) => [w, const SizedBox(height: 12)]),
              const Spacer(),
              ElevatedButton(
                onPressed: _selected == null
                    ? null
                    : () => auth.selectContext(_selected!, grant: _selectedGrant),
                child: const Text('Continue'),
              ),
              TextButton(
                onPressed: auth.logout,
                child: const Text('Sign out'),
              ),
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
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withValues(alpha: 0.08) : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
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
    );
  }
}
