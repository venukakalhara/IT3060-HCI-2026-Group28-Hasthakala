import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/tr.dart';
import '../../../../core/shared_models/user_model.dart';
import '../state/auth_provider.dart';
import '../widgets/status_screen.dart';

// I01 "You're all set!" / "Your artisan setup has started!"
class PurposeConfirmedScreen extends StatelessWidget {
  const PurposeConfirmedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final selling = auth.purposeJustChosen == AccountPurpose.sell;

    return StatusScreen(
      icon: selling ? Icons.storefront_rounded : Icons.check_rounded,
      title: context.tr(selling ? 'artisan_started_title' : 'all_set_title'),
      message: context.tr(selling ? 'artisan_started_sub' : 'all_set_sub'),
      primaryLabel: context.tr(selling ? 'continue_profile' : 'continue_home'),
      onPrimary: auth.finishPurposeConfirmation,
    );
  }
}
