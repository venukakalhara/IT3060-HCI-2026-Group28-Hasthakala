import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/tr.dart';
import '../../../../core/shared_models/support_models.dart';
import '../../../../core/utils/phone_utils.dart';
import 'profile_cover_header.dart';

// invite code + how the family member uses it + copy button
// (no SMS service, so the artisan sends it themselves - DEVIATIONS DV3)
class InviteCodeCard extends StatelessWidget {
  final SupportInviteModel invite;
  const InviteCodeCard({super.key, required this.invite});

  String get _firstName => invite.inviteeName.split(' ').first;

  String _validUntil(BuildContext context) {
    try {
      return DateFormat('d MMM', Localizations.localeOf(context).languageCode)
          .format(invite.expiresAt);
    } catch (_) {
      return DateFormat('d MMM').format(invite.expiresAt);
    }
  }

  // the message is written in the language the artisan is using
  String _message(BuildContext context) => context.tr('invite_message', {
        'name': _firstName,
        'artisan': invite.artisanName,
        'profile': context.tr('nav_profile'),
        'accept': context.tr('accept_invite'),
        'code': invite.code,
        'phone': PhoneUtils.display(invite.phone),
        'date': _validUntil(context),
      });

  Future<void> _copy(BuildContext context) async {
    final copied = context.tr('invite_copied');
    await Clipboard.setData(ClipboardData(text: _message(context)));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(copied)));
  }

  @override
  Widget build(BuildContext context) {
    final steps = [
      context.tr('join_step1'),
      context.tr('join_step2',
          {'profile': context.tr('nav_profile'), 'accept': context.tr('accept_invite')}),
      context.tr('join_step3', {'phone': PhoneUtils.display(invite.phone)}),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primary, width: 1.5),
          ),
          child: Column(
            children: [
              Text(context.tr('invite_code_title'),
                  style: const TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 6),
              // spaced digits are easier to read out over the phone
              Text(invite.code.split('').join(' '),
                  style: const TextStyle(
                      fontSize: 34, fontWeight: FontWeight.w700, letterSpacing: 3)),
              const SizedBox(height: 8),
              ProfileChip(
                icon: Icons.schedule_rounded,
                label: context.tr('valid_until', {'date': _validUntil(context)}),
                color: AppColors.secondaryDark,
              ),
              const SizedBox(height: 6),
              TextButton.icon(
                icon: const Icon(Icons.copy_rounded, size: 20),
                label: Text(context.tr('copy_invite')),
                style: TextButton.styleFrom(minimumSize: const Size(0, 48)),
                onPressed: () => _copy(context),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Text(context.tr('how_joins', {'name': _firstName}),
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
        const SizedBox(height: 10),
        for (var i = 0; i < steps.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 13,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                  child: Text('${i + 1}',
                      style: const TextStyle(
                          color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 13)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(steps[i], style: const TextStyle(height: 1.4)),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
