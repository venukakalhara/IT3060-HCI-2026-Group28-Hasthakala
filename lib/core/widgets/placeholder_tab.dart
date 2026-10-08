import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// TEMPORARY stand-in for a tab whose interface is still being built.
/// Each owner replaces it with their real screen. Must not remain in the
/// final build used for usability testing.
class PlaceholderTab extends StatelessWidget {
  final String title;
  final String interfaceId;
  final String owner;

  const PlaceholderTab({
    super.key,
    required this.title,
    required this.interfaceId,
    required this.owner,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.construction_outlined, size: 48, color: AppColors.textMuted),
              const SizedBox(height: 12),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text('$interfaceId is being built by $owner',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}
