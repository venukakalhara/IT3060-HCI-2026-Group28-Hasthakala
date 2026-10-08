import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/tr.dart';
import '../../../../core/shared_models/support_models.dart';
import '../state/family_support_provider.dart';
import '../widgets/profile_avatar_widget.dart';
import '../widgets/profile_cover_header.dart';
import '../widgets/profile_form_parts.dart';
import '../widgets/support_parts.dart';
import '../widgets/support_scope_toggles.dart';
import 'access_revoked_screen.dart';

// I13 Support User Details (owner).
// update: permissions ("Access updated"). update: revoke (with confirmation).
class SupportUserDetailsScreen extends StatefulWidget {
  final SupportGrantModel grant;
  const SupportUserDetailsScreen({super.key, required this.grant});

  @override
  State<SupportUserDetailsScreen> createState() => _SupportUserDetailsScreenState();
}

class _SupportUserDetailsScreenState extends State<SupportUserDetailsScreen> {
  late SupportScopes _savedScopes;
  late SupportScopes _scopes;

  @override
  void initState() {
    super.initState();
    _savedScopes = widget.grant.scopes;
    _scopes = widget.grant.scopes;
  }

  bool get _hasChanges => !_scopes.sameAs(_savedScopes);

  Future<void> _update() async {
    if (!_scopes.hasAny) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.tr('keep_one_on'))));
      return;
    }
    final support = context.read<FamilySupportProvider>();
    final ok = await support.updateAccess(widget.grant.id, _scopes);
    if (!mounted) return;
    if (ok) setState(() => _savedScopes = _scopes);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(ok
            ? context.tr('access_updated')
            : context.trMessage(support.errorMessage) ?? context.tr('err_try_again'))));
  }

  Future<void> _revoke() async {
    final name = widget.grant.supporterName.split(' ').first;
    final artisan = widget.grant.artisanName;
    // cancel is the filled (safe) button and returns false, like before
    final confirmed = await showChoiceDialog(
      context,
      icon: Icons.person_remove_outlined,
      iconColor: AppColors.error,
      title: context.tr('revoke_title'),
      message: context.tr('revoke_body', {'name': name, 'artisan': artisan}),
      filledLabel: context.tr('cancel'),
      textLabel: context.tr('revoke_access'),
      textColor: AppColors.error,
      filledIsTrue: false,
    );
    if (confirmed != true || !mounted) return;
    final support = context.read<FamilySupportProvider>();
    final ok = await support.revokeAccess(widget.grant.id);
    if (!mounted) return;
    if (ok) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AccessRevokedScreen(supporterName: name)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(context.trMessage(support.errorMessage) ?? context.tr('err_try_again'))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final support = context.watch<FamilySupportProvider>();
    final g = widget.grant;

    return Scaffold(
      appBar: AppBar(title: Text(context.tr('details_title'))),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                children: [
                  // who this is
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        ProfileAvatarWidget(name: g.supporterName, radius: 34, uid: g.supporterId),
                        const SizedBox(height: 10),
                        Text(g.supporterName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700)),
                        if (g.relationship.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(relationshipName(context, g.relationship),
                              style: const TextStyle(color: AppColors.textSecondary)),
                        ],
                        const SizedBox(height: 10),
                        g.isActive
                            ? ProfileChip(
                                icon: Icons.check_circle_outline,
                                label: context.tr('status_active'),
                                color: AppColors.accent,
                              )
                            : ProfileChip(
                                icon: Icons.block_rounded,
                                label: context.tr('status_revoked'),
                                color: AppColors.error,
                              ),
                      ],
                    ),
                  ),

                  FormSectionTitle(context.tr('sec_support_access')),
                  SupportScopeToggles(
                    scopes: _scopes,
                    onChanged: support.isSaving ? null : (s) => setState(() => _scopes = s),
                  ),
                  const SizedBox(height: 12),
                  // reminder that the switches are not saved yet
                  _hasChanges
                      ? FieldHint(context.tr('details_unsaved'), icon: Icons.edit_note_rounded)
                      : FieldHint(context.tr('details_note'),
                          icon: Icons.admin_panel_settings_outlined),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: (support.isSaving || !_hasChanges) ? null : _update,
                    child: Text(context.tr('update_access')),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: support.isSaving ? null : _revoke,
                    icon: const Icon(Icons.person_remove_outlined, size: 20),
                    label: Text(context.tr('revoke_access')),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
