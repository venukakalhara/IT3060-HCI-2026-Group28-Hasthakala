import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/tr.dart';
import '../../../../core/shared_models/support_models.dart';
import '../../../../core/utils/phone_utils.dart';
import '../state/auth_provider.dart';
import '../state/family_support_provider.dart';
import '../widgets/profile_form_parts.dart';
import '../widgets/support_parts.dart';
import '../widgets/support_scope_toggles.dart';
import 'invitation_sent_screen.dart';

// I13 Add Support User - creates supportInvites/{code}
class AddSupportUserScreen extends StatefulWidget {
  const AddSupportUserScreen({super.key});

  @override
  State<AddSupportUserScreen> createState() => _AddSupportUserScreenState();
}

class _AddSupportUserScreenState extends State<AddSupportUserScreen> {
  static const _relationships = [
    'Family Member',
    'Son / Daughter',
    'Spouse',
    'Sibling',
    'Relative',
  ];

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String _relationship = _relationships.first;
  SupportScopes _scopes =
      const SupportScopes(products: true, orders: true, communication: true);
  String? _scopeError;

  @override
  void initState() {
    super.initState();
    // only to redraw the summary line with the name
    _nameController.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final formOk = _formKey.currentState!.validate();
    setState(() => _scopeError =
        _scopes.hasAny ? null : 'Turn on at least one activity this person may help with');
    if (!formOk || !_scopes.hasAny) return;

    final auth = context.read<AuthProvider>();
    final support = context.read<FamilySupportProvider>();
    final user = auth.currentUser!;
    final invite = await support.sendInvitation(
      artisanId: user.uid,
      artisanName: user.displayName,
      inviteeName: _nameController.text.trim(),
      relationship: _relationship,
      phone: PhoneUtils.normalize(_phoneController.text),
      scopes: _scopes,
    );
    if (!mounted || invite == null) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => InvitationSentScreen(invite: invite)),
    );
  }

  // "Vihara will be able to help with: Orders, Customer messages" only an example only
  String _summary(BuildContext context) {
    final parts = [
      if (_scopes.products) context.tr('nav_products'),
      if (_scopes.orders) context.tr('nav_orders'),
      if (_scopes.communication) context.tr('scope_messages'),
    ];
    final first = _nameController.text.trim().split(' ').first;
    final name = first.isEmpty ? context.tr('this_person') : first;
    return context.tr('scope_summary', {'name': name, 'scopes': parts.join(', ')});
  }

  @override
  Widget build(BuildContext context) {
    final support = context.watch<FamilySupportProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(context.tr('add_support_user'))),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  children: [
                    FormSectionTitle(context.tr('sec_person')),
                    LabelledField(
                      label: context.tr('label_full_name'),
                      child: TextFormField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          hintText: context.tr('hint_full_name'),
                          prefixIcon:
                              const Icon(Icons.person_outline, color: AppColors.textSecondary),
                        ),
                        validator: (v) => context.trMessage((v == null || v.trim().length < 2)
                            ? 'Please enter their full name'
                            : null),
                      ),
                    ),
                    const SizedBox(height: 16),
                    LabelledField(
                      label: context.tr('label_relationship'),
                      child: DropdownButtonFormField<String>(
                        initialValue: _relationship,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          prefixIcon:
                              Icon(Icons.diversity_3_outlined, color: AppColors.textSecondary),
                        ),
                        items: _relationships
                            .map((r) => DropdownMenuItem(
                                value: r, child: Text(relationshipName(context, r))))
                            .toList(),
                        onChanged: (v) => setState(() => _relationship = v ?? _relationship),
                      ),
                    ),
                    const SizedBox(height: 16),
                    LabelledField(
                      label: context.tr('label_phone'),
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: 'e.g. 077 123 4567',
                          prefixIcon:
                              const Icon(Icons.phone_outlined, color: AppColors.textSecondary),
                        ),
                        validator: (v) => context.trMessage(PhoneUtils.validate(v)),
                      ),
                    ),

                    FormSectionTitle(context.tr('sec_support_access')),
                    SupportScopeToggles(
                      scopes: _scopes,
                      onChanged: (s) => setState(() {
                        _scopes = s;
                        if (s.hasAny) _scopeError = null;
                      }),
                    ),
                    const SizedBox(height: 12),
                    if (_scopes.hasAny)
                      FieldHint(_summary(context), ok: true)
                    else if (_scopeError == null)
                      FieldHint(context.tr('scope_none_hint')),
                    if (_scopeError != null)
                      Text(context.trMessage(_scopeError)!,
                          style: const TextStyle(color: AppColors.error)),
                    if (support.errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Text(context.trMessage(support.errorMessage)!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.error)),
                    ],
                  ],
                ),
              ),

              // buttons at the bottom like the other forms
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton.icon(
                      onPressed: support.isSaving ? null : _send,
                      icon: support.isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: AppColors.onPrimary),
                            )
                          : const Icon(Icons.send_rounded),
                      label: Text(context.tr('send_invitation')),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      onPressed: support.isSaving ? null : () => Navigator.pop(context),
                      child: Text(context.tr('cancel')),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
