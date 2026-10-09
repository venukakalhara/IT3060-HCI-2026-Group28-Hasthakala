import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/tr.dart';
import '../../../../core/utils/input_validators.dart';
import '../state/auth_provider.dart';
import '../widgets/auth_field.dart';
import '../widgets/status_screen.dart';

// I01 Reset Password + Check your email
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await context.read<AuthProvider>().sendPasswordReset(_emailController.text.trim());
    if (ok && mounted) setState(() => _sent = true);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (_sent) {
      return StatusScreen(
        icon: Icons.mark_email_read_outlined,
        title: context.tr('check_email_title'),
        message: context.tr('check_email_sub', {'email': _emailController.text.trim()}),
        primaryLabel: context.tr('back_to_sign_in'),
        onPrimary: () => Navigator.pop(context),
        secondaryLabel: context.tr('resend'),
        onSecondary: _send,
      );
    }

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: CenteredFormLayout(
            children: [
              Center(
                child: CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.10),
                  child: const Icon(Icons.lock_reset_rounded, size: 36, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 20),
              Text(context.tr('reset_title'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text(context.tr('reset_sub'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 28),
              AuthField(
                label: context.tr('email'),
                hint: context.tr('email_hint'),
                icon: Icons.mail_outline_rounded,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _send(),
                validator: InputValidators.validateEmail,
              ),
              if (auth.errorMessage != null) ...[
                const SizedBox(height: 10),
                Text(context.trMessage(auth.errorMessage)!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.error)),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: auth.isLoading ? null : _send,
                child: Text(context.tr('send_reset_link')),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(context.tr('back_to_sign_in')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
