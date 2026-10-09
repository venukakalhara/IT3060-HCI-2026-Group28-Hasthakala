import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/tr.dart';
import '../../../../core/utils/input_validators.dart';
import '../state/auth_provider.dart';
import '../widgets/auth_field.dart';
import 'register_screen.dart';
import 'reset_password_screen.dart';

// I01 Welcome Back + Signing you in
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn(AuthProvider auth) async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await auth.login(_emailController.text.trim(), _passwordController.text);
    if (!ok) _passwordController.clear();
    // on success AuthGate moves on to "Checking your available access..."
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (auth.isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/hasthakala_logo.png', width: 96),
              const SizedBox(height: 24),
              const CircularProgressIndicator(color: AppColors.primary),
              const SizedBox(height: 16),
              Text(context.tr('signing_in'),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text(context.tr('signing_in_sub'),
                  style: const TextStyle(color: AppColors.textSecondary)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: CenteredFormLayout(
            children: [
              Center(child: Image.asset('assets/images/hasthakala_logo.png', width: 104)),
              const SizedBox(height: 20),
              Text(context.tr('welcome_back'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text(context.tr('sign_in_sub'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 28),
              if (auth.errorMessage != null) _ErrorBanner(context.trMessage(auth.errorMessage)!),
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
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _signIn(auth),
                validator: InputValidators.validatePassword,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    auth.clearError();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const ResetPasswordScreen()));
                  },
                  child: Text(context.tr('forgot_password')),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(onPressed: () => _signIn(auth), child: Text(context.tr('sign_in'))),
              const SizedBox(height: 20),
              _OrDivider(context.tr('or_continue_with')),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () {
                  auth.clearError();
                  auth.loginWithGoogle();
                },
                icon: const Icon(Icons.g_mobiledata_rounded, size: 30),
                label: Text(context.tr('google_continue')),
              ),
              const SizedBox(height: 10),
              // shown as in the hi-fi, but not built yet (DEVIATIONS DV2)
              Row(
                children: [
                  Expanded(
                    child: _SoonButton(
                      icon: Icons.fingerprint_rounded,
                      label: context.tr('biometric_sign_in'),
                      message: context.tr('coming_soon_bio'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _SoonButton(
                      icon: Icons.key_rounded,
                      label: context.tr('passkey_sign_in'),
                      message: context.tr('coming_soon_passkey'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(context.tr('new_here')),
                  TextButton(
                    onPressed: () {
                      auth.clearError();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const RegisterScreen()));
                    },
                    child: Text(context.tr('create_account')),
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

class _OrDivider extends StatelessWidget {
  final String text;
  const _OrDivider(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(text, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        ),
        const Expanded(child: Divider(color: AppColors.border)),
      ],
    );
  }
}

// sign in options from the hi-fi that aren't ready yet - tapping says so
class _SoonButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String message;

  const _SoonButton({required this.icon, required this.label, required this.message});

  void _showSoon(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.secondaryDark, size: 28),
        ),
        title: Text(ctx.tr('coming_soon_title'), textAlign: TextAlign.center),
        content: Text(message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textSecondary, height: 1.4)),
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(ctx.tr('ok_got_it')),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => _showSoon(context),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textSecondary,
        side: const BorderSide(color: AppColors.border),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 6),
          Flexible(
            child: Text(label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 6),
          // small tag so it's clear before tapping
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(context.tr('soon_tag'),
                style: const TextStyle(
                    fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.secondaryDark)),
          ),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String text;
  const _ErrorBanner(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(color: AppColors.error))),
        ],
      ),
    );
  }
}
