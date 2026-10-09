import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/tr.dart';

// I01 Checking your available access - shown while the account and contexts load
class CheckingAccessScreen extends StatelessWidget {
  const CheckingAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(child: Image.asset('assets/images/hasthakala_logo.png', width: 96)),
                const SizedBox(height: 24),
                Text(context.tr('checking_access'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                const SizedBox(height: 24),
                _Step(text: context.tr('check_verified'), state: _StepState.done),
                _Step(text: context.tr('check_profiles'), state: _StepState.working),
                _Step(text: context.tr('check_workspace'), state: _StepState.waiting),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum _StepState { done, working, waiting }

class _Step extends StatelessWidget {
  final String text;
  final _StepState state;
  const _Step({required this.text, required this.state});

  @override
  Widget build(BuildContext context) {
    final done = state == _StepState.done;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: done ? AppColors.primary.withValues(alpha: 0.08) : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: done ? AppColors.primary : AppColors.border),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 22,
            height: 22,
            child: switch (state) {
              _StepState.done => const Icon(Icons.check_circle, color: AppColors.primary, size: 22),
              _StepState.working =>
                const CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.primary),
              _StepState.waiting =>
                const Icon(Icons.radio_button_unchecked, color: AppColors.textMuted, size: 22),
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text,
                style: TextStyle(
                    fontWeight: done ? FontWeight.w600 : FontWeight.w500,
                    color: state == _StepState.waiting ? AppColors.textSecondary : AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }
}
