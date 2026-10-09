import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/tr.dart';
import '../../../../core/utils/phone_utils.dart';
import '../state/auth_provider.dart';
import '../state/family_support_provider.dart';
import '../widgets/profile_form_parts.dart';
import '../widgets/support_parts.dart';

// I13 - supporter enters phone number + invite code (see DEVIATIONS DV4)
// creates the support grant, user stays logged in as themselves
class AcceptSupportInvitationScreen extends StatefulWidget {
  const AcceptSupportInvitationScreen({super.key});

  @override
  State<AcceptSupportInvitationScreen> createState() =>
      _AcceptSupportInvitationScreenState();
}

class _AcceptSupportInvitationScreenState extends State<AcceptSupportInvitationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _accept() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final support = context.read<FamilySupportProvider>();
    final user = auth.currentUser!;
    final grant = await support.acceptInvitation(
      code: _codeController.text.trim(),
      phone: PhoneUtils.normalize(_phoneController.text),
      supporterId: user.uid,
      supporterName: user.displayName,
    );
    if (!mounted || grant == null) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        icon: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_circle, color: AppColors.accent, size: 44),
        ),
        title: Text(ctx.tr('now_supporting', {'name': grant.artisanName}),
            textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(ctx.tr('can_help_with'),
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 10),
            ScopeChips(scopes: grant.scopes),
            const SizedBox(height: 14),
            Text(
              ctx.tr('choose_to_start',
                  {'ctx': ctx.tr('ctx_supporting', {'name': grant.artisanName})}),
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary, height: 1.4),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(ctx.tr('continue')),
            ),
          ),
        ],
      ),
    );
    if (!mounted) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
    await auth.refreshSession();
  }

  @override
  Widget build(BuildContext context) {
    final support = context.watch<FamilySupportProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(context.tr('accept_invite'))),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                  children: [
                    // same photo as the artisan's Family Assistance screen
                    PhotoHeaderCard(
                      image: 'assets/images/family_banner.jpg',
                      text: context.tr('accept_intro'),
                    ),
                    const SizedBox(height: 18),
                    LabelledField(
                      label: context.tr('label_your_phone'),
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: 'e.g. 077 123 4567',
                          prefixIcon: Icon(Icons.phone_outlined, color: AppColors.textSecondary),
                        ),
                        validator: (v) => context.trMessage(PhoneUtils.validate(v)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    LabelledField(
                      label: context.tr('label_invite_code'),
                      child: TextFormField(
                        controller: _codeController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: 8),
                        decoration: const InputDecoration(hintText: '000000'),
                        validator: (v) => context.trMessage(
                            RegExp(r'^[0-9]{6}$').hasMatch((v ?? '').trim())
                                ? null
                                : 'Enter the 6-digit code'),
                      ),
                    ),
                    if (support.errorMessage != null) ...[
                      const SizedBox(height: 4),
                      Text(context.trMessage(support.errorMessage)!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.error)),
                    ],
                    const SizedBox(height: 14),
                    TrustNote(context.tr('accept_note')),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                child: ElevatedButton(
                  onPressed: support.isSaving ? null : _accept,
                  child: support.isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: AppColors.onPrimary),
                        )
                      : Text(context.tr('accept_invitation')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
