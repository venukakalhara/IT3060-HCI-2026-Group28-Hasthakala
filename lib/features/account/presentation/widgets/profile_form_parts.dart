import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

// small pieces shared by Complete Your Artisan Profile and Edit Artisan Profile

// section title with the terracotta bar from the hi-fi
class FormSectionTitle extends StatelessWidget {
  final String text;
  const FormSectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

// label above a field, same as the sign in / create account fields
class LabelledField extends StatelessWidget {
  final String label;
  final Widget child;
  final Widget? helper;

  const LabelledField({super.key, required this.label, required this.child, this.helper});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 6),
        child,
        if (helper != null) ...[const SizedBox(height: 6), helper!],
      ],
    );
  }
}

// one line of grey help text with an icon,''green when it's fine''
class FieldHint extends StatelessWidget {
  final String text;
  final bool ok;
  final IconData icon;

  const FieldHint(this.text, {super.key, this.ok = false, this.icon = Icons.info_outline_rounded});

  @override
  Widget build(BuildContext context) {
    final color = ok ? AppColors.accent : AppColors.textSecondary;
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(ok ? Icons.check_circle_rounded : icon, size: 16, color: color),
          const SizedBox(width: 6),
          Expanded(child: Text(text, style: TextStyle(color: color, fontSize: 13))),
        ],
      ),
    );
  }
}

// dialog with a round icon, centred text and two stacked buttons.
// returns true when the filled button is pressed, false for the text button.
Future<bool?> showChoiceDialog(
  BuildContext context, {
  required IconData icon,
  required Color iconColor,
  required String title,
  required String message,
  required String filledLabel,
  required String textLabel,
  Color? textColor,
  bool filledIsTrue = true,
}) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      icon: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 28),
      ),
      title: Text(title, textAlign: TextAlign.center),
      content: Text(message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textSecondary, height: 1.4)),
      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      actions: [
        SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, filledIsTrue),
                child: Text(filledLabel),
              ),
              const SizedBox(height: 6),
              TextButton(
                onPressed: () => Navigator.pop(ctx, !filledIsTrue),
                style: TextButton.styleFrom(
                  foregroundColor: textColor ?? AppColors.primary,
                  minimumSize: const Size.fromHeight(48),
                ),
                child: Text(textLabel),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
