import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/tr.dart';
import '../state/auth_provider.dart';
import '../widgets/status_screen.dart';

// I01 Account Created
class AccountCreatedScreen extends StatelessWidget {
  const AccountCreatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StatusScreen(
      icon: Icons.check_rounded,
      title: context.tr('account_created_title'),
      message: context.tr('account_created_sub'),
      primaryLabel: context.tr('continue'),
      onPrimary: context.read<AuthProvider>().continueAfterAccountCreated,
    );
  }
}
