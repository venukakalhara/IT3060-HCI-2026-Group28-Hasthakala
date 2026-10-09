import 'package:flutter/material.dart';

import '../../../../core/localization/tr.dart';
import '../../../../core/shared_models/support_models.dart';
import '../widgets/invite_code_card.dart';
import '../widgets/status_screen.dart';
import 'add_support_user_screen.dart';

// I13 Invitation sent. Shows the 6-digit code.
class InvitationSentScreen extends StatelessWidget {
  final SupportInviteModel invite;
  const InvitationSentScreen({super.key, required this.invite});

  @override
  Widget build(BuildContext context) {
    final firstName = invite.inviteeName.split(' ').first;
    return StatusScreen(
      icon: Icons.send_rounded,
      title: context.tr('inv_sent_title'),
      message: context.tr('inv_sent_body', {'name': firstName}),
      extra: InviteCodeCard(invite: invite),
      primaryLabel: context.tr('back_to_fa'),
      onPrimary: () => Navigator.pop(context),
      secondaryLabel: context.tr('add_another_user'),
      onSecondary: () => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const AddSupportUserScreen())),
    );
  }
}
