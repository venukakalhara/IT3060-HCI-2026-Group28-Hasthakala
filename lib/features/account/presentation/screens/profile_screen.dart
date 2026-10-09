import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/shared_models/artisan_profile_model.dart';
import '../../../../core/shared_models/support_models.dart';
import '../state/artisan_profile_provider.dart';
import '../state/auth_provider.dart';
import '../widgets/craft_name.dart';
import '../widgets/profile_cover_header.dart';
import '../widgets/profile_covers.dart';
import '../../../../core/localization/tr.dart';
import 'accept_support_invitation_screen.dart';
import 'buyer_profile_screen.dart';
import 'family_assistance_screen.dart';
import 'language_selection_screen.dart';
import 'my_artisan_profile_screen.dart';

// Profile tab - the entry point to I05 Manage and I13.
// What it shows depends on the active context.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _confirmSignOut(BuildContext context, AuthProvider auth) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ctx.tr('sign_out_title')),
        content: Text(ctx.tr('sign_out_body')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(ctx.tr('cancel'))),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(ctx.tr('sign_out')),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
    await auth.logout(); // AuthGate then shows the sign-in screen
  }

  // name of the context we are in now, for the switch card
  String _contextName(BuildContext context, AuthProvider auth) {
    if (auth.isArtisanContext) return context.tr('ctx_artisan');
    if (auth.isSupporterContext) return context.tr('ctx_supporter');
    return context.tr('ctx_buyer');
  }

  // "Products, Orders" in the chosen language
  String _scopeText(BuildContext context, SupportScopes scopes) {
    final parts = [
      if (scopes.products) context.tr('nav_products'),
      if (scopes.orders) context.tr('nav_orders'),
      if (scopes.communication) context.tr('scope_messages'),
    ];
    return parts.isEmpty ? context.tr('scope_none') : parts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;
    if (auth.isBuyerContext && user != null) {
      return BuyerProfileScreen(
        user: user,
        onSignOut: () => _confirmSignOut(context, auth),
        onSwitchContext: auth.availableContextCount > 1
            ? () {
                Navigator.of(context).popUntil((route) => route.isFirst);
                auth.switchContext();
              }
            : null,
      );
    }

    final name = user?.displayName ?? '';

    Widget header;
    if (auth.isArtisanContext && user != null) {
      header = _ArtisanHeader(uid: user.uid, fallbackName: name, photoUrl: user.photoUrl);
    } else if (auth.isSupporterContext && auth.activeGrant != null) {
      header = ProfileCoverHeader(
        uid: user?.uid,
        name: name,
        photoUrl: user?.photoUrl,
        chip: ProfileChip(
          icon: Icons.verified_user_outlined,
          label: context.tr('ctx_supporting', {'name': auth.activeGrant!.artisanName}),
          color: AppColors.accent,
        ),
        details: [_EmailText(user?.email ?? '')],
      );
    } else {
      header = ProfileCoverHeader(
        uid: user?.uid,
        name: name,
        photoUrl: user?.photoUrl,
        chip: ProfileChip(icon: Icons.shopping_bag_outlined, label: context.tr('ctx_buyer')),
        details: [_EmailText(user?.email ?? '')],
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(context.tr('nav_profile'))),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                children: [
                  header,

                  // artisan: own profile and family assistance (hi-fi frame 20)
                  if (auth.isArtisanContext) ...[
                    _SectionLabel(context.tr('profile_section_business')),
                    _MenuCard(
                      icon: Icons.person_outline,
                      title: context.tr('profile_my_artisan'),
                      subtitle: context.tr('profile_my_artisan_sub'),
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const MyArtisanProfileScreen())),
                    ),
                    _MenuCard(
                      icon: Icons.people_alt_outlined,
                      title: context.tr('family_assistance'),
                      subtitle: context.tr('family_assistance_sub'),
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const FamilyAssistanceScreen())),
                    ),
                  ],

                  // buyer can accept an invite to help an artisan
                  if (auth.isBuyerContext) ...[
                    _SectionLabel(context.tr('profile_section_help')),
                    _MenuCard(
                      icon: Icons.handshake_outlined,
                      title: context.tr('accept_invite'),
                      subtitle: context.tr('accept_invite_sub'),
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(
                              builder: (_) => const AcceptSupportInvitationScreen())),
                    ),
                  ],

                  if (auth.isSupporterContext && auth.activeGrant != null) ...[
                    _SectionLabel(context.tr('profile_section_access')),
                    _MenuCard(
                      icon: Icons.verified_user_outlined,
                      iconColor: AppColors.accent,
                      title: context.tr('ctx_supporting', {'name': auth.activeGrant!.artisanName}),
                      subtitle: context.tr('profile_supporting_sub',
                          {'scopes': _scopeText(context, auth.activeGrant!.scopes)}),
                    ),
                  ],

                  _SectionLabel(context.tr('profile_section_settings')),
                  _MenuCard(
                    icon: Icons.translate,
                    title: context.tr('language'),
                    subtitle: context.tr('language_sub'),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const LanguageSelectionScreen(fromProfile: true))),
                  ),
                  if (auth.availableContextCount > 1)
                    _MenuCard(
                      icon: Icons.swap_horiz,
                      title: context.tr('switch_context'),
                      subtitle: context.tr('switch_context_sub', {'ctx': _contextName(context, auth)}),
                      onTap: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        auth.switchContext();
                      },
                    ),
                ],
              ),
            ),

            // sign out stays at the bottom, away from the other actions
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: OutlinedButton.icon(
                onPressed: () => _confirmSignOut(context, auth),
                icon: const Icon(Icons.logout_rounded, size: 20),
                label: Text(context.tr('sign_out')),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// header for the artisan context - reads the artisan profile for the craft
class _ArtisanHeader extends StatefulWidget {
  final String uid;
  final String fallbackName;
  final String? photoUrl;

  const _ArtisanHeader({required this.uid, required this.fallbackName, this.photoUrl});

  @override
  State<_ArtisanHeader> createState() => _ArtisanHeaderState();
}

class _ArtisanHeaderState extends State<_ArtisanHeader> {
  late final Stream<ArtisanProfileModel?> _profile;

  @override
  void initState() {
    super.initState();
    _profile = context.read<ArtisanProfileProvider>().watchProfile(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ArtisanProfileModel?>(
      stream: _profile,
      builder: (context, snapshot) {
        final p = snapshot.data;
        return ArtisanCoverStyle(
          uid: widget.uid,
          builder: (context, style) => ProfileCoverHeader(
          coverStyle: style,
          uid: widget.uid,
          name: (p != null && p.displayName.isNotEmpty) ? p.displayName : widget.fallbackName,
          photoUrl: p?.photoUrl ?? widget.photoUrl,
          chip: ProfileChip(
            icon: Icons.palette_outlined,
            label: (p != null && p.craftType.isNotEmpty)
                ? context.tr('craft_artisan', {'craft': craftName(context, p.craftType)})
                : context.tr('ctx_artisan'),
          ),
          details: [
            if (p != null && p.location.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(p.location,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: AppColors.textSecondary)),
                  ),
                ],
              ),
          ],
        ),
        );
      },
    );
  }
}

class _EmailText extends StatelessWidget {
  final String email;
  const _EmailText(this.email);

  @override
  Widget build(BuildContext context) {
    return Text(email,
        textAlign: TextAlign.center,
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13));
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 22, 4, 10),
      child: Text(text,
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
    );
  }
}

// same card applied for I01 "How will you start" options
class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Color iconColor;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.iconColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
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
                    color: iconColor.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: iconColor, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                      const SizedBox(height: 2),
                      Text(subtitle, style: const TextStyle(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                if (onTap != null) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right_rounded, color: AppColors.primary),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
