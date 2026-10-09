import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/tr.dart';
import '../state/auth_provider.dart';
import '../widgets/status_screen.dart';

// shown when the artisan removes support access while it's being used
class SupportAccessRemovedScreen extends StatelessWidget {
  const SupportAccessRemovedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return StatusScreen(
      icon: Icons.lock_outline_rounded,
      color: AppColors.secondaryDark,
      title: context.tr('support_removed_title'),
      message: context.tr('support_removed_sub', {'name': auth.lostArtisanName ?? ''}),
      primaryLabel: context.tr('continue'),
      onPrimary: auth.acknowledgeSupportLoss,
    );
  }
}
