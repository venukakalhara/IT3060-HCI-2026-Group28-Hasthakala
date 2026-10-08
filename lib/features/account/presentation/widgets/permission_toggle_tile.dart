import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class PermissionToggleTile extends StatelessWidget {
  final String title;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  const PermissionToggleTile({
    Key? key,
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(description, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        activeColor: AppColors.primary,
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
