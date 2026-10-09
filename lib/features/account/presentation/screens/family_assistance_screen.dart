import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/tr.dart';
import '../../../../core/shared_models/support_models.dart';
import '../state/auth_provider.dart';
import '../state/family_support_provider.dart';
import '../widgets/invite_code_card.dart';
import '../widgets/profile_avatar_widget.dart';
import '../widgets/profile_cover_header.dart';
import '../widgets/profile_form_parts.dart';
import '../widgets/support_parts.dart';
import 'add_support_user_screen.dart';
import 'support_user_details_screen.dart';

// I13 Family Assistance
// read: authorised support users + pending invitations.
// delete: cancel a pending invitation.
class FamilyAssistanceScreen extends StatefulWidget {
  const FamilyAssistanceScreen({super.key});

  @override
  State<FamilyAssistanceScreen> createState() => _FamilyAssistanceScreenState();
}

class _FamilyAssistanceScreenState extends State<FamilyAssistanceScreen> {
  late final Stream<List<SupportGrantModel>> _grants;
  late final Stream<List<SupportInviteModel>> _invites;

  @override
  void initState() {
    super.initState();
    final artisanId = context.read<AuthProvider>().currentUser!.uid;
    final support = context.read<FamilySupportProvider>();
    _grants = support.grantsFor(artisanId);
    _invites = support.pendingInvitesFor(artisanId);
  }

  void _showCode(SupportInviteModel invite) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(ctx.tr('invite_for', {'name': invite.inviteeName}),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              InviteCodeCard(invite: invite),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _cancelInvite(SupportInviteModel invite) async {
    // keep is the filled (safe) button and returns false, like before
    final confirmed = await showChoiceDialog(
      context,
      icon: Icons.event_busy_outlined,
      iconColor: AppColors.error,
      title: context.tr('cancel_invite_title'),
      message: context.tr('cancel_invite_body', {'name': invite.inviteeName, 'code': invite.code}),
      filledLabel: context.tr('keep'),
      textLabel: context.tr('cancel_invitation'),
      textColor: AppColors.error,
      filledIsTrue: false,
    );
    if (confirmed != true || !mounted) return;
    final support = context.read<FamilySupportProvider>();
    final ok = await support.cancelInvitation(invite.code);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(ok
          ? context.tr('invite_cancelled')
          : context.trMessage(support.errorMessage) ?? context.tr('err_try_again')),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('family_assistance'))),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                children: [
                  const _Header(),

                  FormSectionTitle(context.tr('fa_sec_users')),
                  StreamBuilder<List<SupportGrantModel>>(
                    stream: _grants,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return _EmptyCard(
                          icon: Icons.cloud_off_rounded,
                          title: context.tr('fa_load_error'),
                        );
                      }
                      if (!snapshot.hasData) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                        );
                      }
                      final active = snapshot.data!.where((g) => g.isActive).toList();
                      if (active.isEmpty) {
                        return _EmptyCard(
                          icon: Icons.group_add_outlined,
                          title: context.tr('fa_empty_title'),
                          subtitle: context.tr('fa_empty_sub'),
                        );
                      }
                      return Column(
                        children: active
                            .map((g) => _PersonCard(
                                  name: g.supporterName,
                                  detail: relationshipName(context, g.relationship),
                                  chipText: context.tr('status_active'),
                                  chipColor: AppColors.accent,
                                  scopes: g.scopes,
                                  uid: g.supporterId,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => SupportUserDetailsScreen(grant: g)),
                                  ),
                                ))
                            .toList(),
                      );
                    },
                  ),

                  StreamBuilder<List<SupportInviteModel>>(
                    stream: _invites,
                    builder: (context, snapshot) {
                      final invites = snapshot.data ?? const [];
                      if (invites.isEmpty) return const SizedBox.shrink();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          FormSectionTitle(context.tr('fa_sec_pending')),
                          ...invites.map((i) => _InviteCard(
                                invite: i,
                                onShare: i.isExpired ? null : () => _showCode(i),
                                onCancel: () => _cancelInvite(i),
                              )),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 8),
                  TrustNote(context.tr('fa_trust')),
                ],
              ),
            ),

            // main action at the bottom like the other screens
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.person_add_alt_1_outlined),
                label: Text(context.tr('add_support_user')),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const AddSupportUserScreen())),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// family photo with the intro line under it
class _Header extends StatelessWidget {
  const _Header();

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
          SizedBox(
            height: 150,
            child: Image.asset('assets/images/family_banner.jpg', fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
            child: Text(context.tr('fa_intro'),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, height: 1.4)),
          ),
        ],
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;

  const _EmptyCard({required this.icon, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
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
            child: Icon(icon, color: AppColors.primary, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!, style: const TextStyle(color: AppColors.textSecondary)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// one active support user
class _PersonCard extends StatelessWidget {
  final String name;
  final String detail;
  final String chipText;
  final Color chipColor;
  final SupportScopes scopes;
  final VoidCallback onTap;
  final String? uid;

  const _PersonCard({
    required this.name,
    required this.detail,
    required this.chipText,
    required this.chipColor,
    required this.scopes,
    required this.onTap,
    this.uid,
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
                ProfileAvatarWidget(name: name, radius: 24, uid: uid),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                      const SizedBox(height: 2),
                      Text(detail, style: const TextStyle(color: AppColors.textSecondary)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          ProfileChip(
                              icon: Icons.check_circle_outline, label: chipText, color: chipColor),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ScopeChips(scopes: scopes),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right_rounded, color: AppColors.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// one pending (or expired) invitation with share and cancel
class _InviteCard extends StatelessWidget {
  final SupportInviteModel invite;
  final VoidCallback? onShare;
  final VoidCallback onCancel;

  const _InviteCard({required this.invite, required this.onShare, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    final expired = invite.isExpired;
    final lang = Localizations.localeOf(context).languageCode;
    String until;
    try {
      until = DateFormat.MMMd(lang).format(invite.expiresAt);
    } catch (_) {
      until = DateFormat.MMMd('en').format(invite.expiresAt);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              ProfileAvatarWidget(name: invite.inviteeName, radius: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(invite.inviteeName,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    if (invite.relationship.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(relationshipName(context, invite.relationship),
                          style: const TextStyle(color: AppColors.textSecondary)),
                    ],
                    const SizedBox(height: 8),
                    ProfileChip(
                      icon: expired ? Icons.timer_off_outlined : Icons.schedule_rounded,
                      label: context.tr(expired ? 'status_expired' : 'status_pending'),
                      color: expired ? AppColors.error : AppColors.secondaryDark,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            expired
                ? context.tr('invite_expired_hint')
                : context.tr('invite_code_line', {'code': invite.code, 'date': until}),
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              if (onShare != null)
                Expanded(
                  child: TextButton.icon(
                    onPressed: onShare,
                    icon: const Icon(Icons.share_outlined, size: 20),
                    label: Text(context.tr('invite_share')),
                    style: TextButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                  ),
                ),
              Expanded(
                child: TextButton.icon(
                  onPressed: onCancel,
                  icon: const Icon(Icons.close_rounded, size: 20),
                  label: Text(context.tr('invite_cancel')),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.error,
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
