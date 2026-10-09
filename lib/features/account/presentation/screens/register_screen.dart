import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/tr.dart';
import '../../../../core/utils/input_validators.dart';
import '../state/auth_provider.dart';
import '../widgets/auth_field.dart';

// I01 Create Account. Shop/Sell is chosen on the next screen.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _acceptedTerms = false;
  bool _showTermsError = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  bool get _passwordLongEnough => _passwordController.text.length >= 6;
  bool get _passwordsMatch =>
      _confirmController.text.isNotEmpty && _confirmController.text == _passwordController.text;

  Future<void> _create() async {
    final formOk = _formKey.currentState!.validate();
    setState(() => _showTermsError = !_acceptedTerms);
    if (!formOk || !_acceptedTerms) return;

    final auth = context.read<AuthProvider>();
    final ok = await auth.createAccount(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      displayName: _nameController.text.trim(),
    );
    // AuthGate shows "Account Created!" underneath this screen
    if (ok && mounted) Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _showTerms() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ctx.tr('terms_title')),
        content: SingleChildScrollView(child: Text(ctx.tr('terms_body'))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(ctx.tr('close'))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: CenteredFormLayout(
            children: [
              Text(context.tr('create_account_title'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text(context.tr('create_account_sub'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 24),
              if (auth.errorMessage != null) ...[
                Text(context.trMessage(auth.errorMessage)!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.error)),
                const SizedBox(height: 12),
              ],
              AuthField(
                label: context.tr('full_name'),
                hint: context.tr('full_name_hint'),
                icon: Icons.person_outline_rounded,
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                validator: (v) =>
                    (v == null || v.trim().length < 2) ? 'Please enter your full name' : null,
              ),
              const SizedBox(height: 16),
              AuthField(
                label: context.tr('email'),
                hint: context.tr('email_hint'),
                icon: Icons.mail_outline_rounded,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: InputValidators.validateEmail,
              ),
              const SizedBox(height: 16),
              AuthField(
                label: context.tr('password'),
                hint: context.tr('password_hint'),
                icon: Icons.lock_outline_rounded,
                controller: _passwordController,
                isPassword: true,
                textInputAction: TextInputAction.next,
                onChanged: (_) => setState(() {}),
                validator: InputValidators.validatePassword,
              ),
              const SizedBox(height: 6),
              _CheckLine(ok: _passwordLongEnough, text: context.tr('password_rule')),
              const SizedBox(height: 16),
              AuthField(
                label: context.tr('confirm_password'),
                hint: context.tr('confirm_password_hint'),
                icon: Icons.lock_outline_rounded,
                controller: _confirmController,
                isPassword: true,
                onChanged: (_) => setState(() {}),
                extraSuffix: _passwordsMatch
                    ? Tooltip(
                        message: context.tr('passwords_match'),
                        child: const Icon(Icons.check_circle, color: AppColors.accent),
                      )
                    : null,
                validator: (v) =>
                    v != _passwordController.text ? 'Passwords do not match' : null,
              ),
              const SizedBox(height: 12),
              // the whole row is tappable, not just the small box
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => setState(() {
                  _acceptedTerms = !_acceptedTerms;
                  if (_acceptedTerms) _showTermsError = false;
                }),
                child: Row(
                  children: [
                    Checkbox(
                      value: _acceptedTerms,
                      onChanged: (v) => setState(() {
                        _acceptedTerms = v ?? false;
                        if (_acceptedTerms) _showTermsError = false;
                      }),
                    ),
                    Expanded(child: Text(context.tr('agree_terms'))),
                    TextButton(onPressed: _showTerms, child: Text(context.tr('view'))),
                  ],
                ),
              ),
              if (_showTermsError)
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(context.tr('err_terms'),
                      style: const TextStyle(color: AppColors.error, fontSize: 12)),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: auth.isLoading ? null : _create,
                child: auth.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onPrimary))
                    : Text(context.tr('create_account')),
              ),
              const SizedBox(height: 12),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(context.tr('have_account')),
                  TextButton(
                    onPressed: () {
                      auth.clearError();
                      Navigator.pop(context);
                    },
                    child: Text(context.tr('sign_in')),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// small rule line under the password, turns green when met
class _CheckLine extends StatelessWidget {
  final bool ok;
  final String text;
  const _CheckLine({required this.ok, required this.text});

  @override
  Widget build(BuildContext context) {
    final color = ok ? AppColors.accent : AppColors.textSecondary;
    return Row(
      children: [
        Icon(ok ? Icons.check_circle : Icons.radio_button_unchecked, size: 16, color: color),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(color: color, fontSize: 12)),
      ],
    );
  }
}
