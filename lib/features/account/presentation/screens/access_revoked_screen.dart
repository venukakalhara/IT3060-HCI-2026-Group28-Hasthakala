import 'package:flutter/material.dart';

import '../../../../core/localization/tr.dart';
import '../widgets/status_screen.dart';
import '../widgets/support_parts.dart';

// I13 Access revoked
class AccessRevokedScreen extends StatelessWidget {
  final String supporterName;
  const AccessRevokedScreen({super.key, required this.supporterName});

  @override
  Widget build(BuildContext context) {
    return StatusScreen(
      icon: Icons.check_rounded,
      title: context.tr('revoked_title'),
      message: context.tr('revoked_body', {'name': supporterName}),
      extra: TrustNote(context.tr('revoked_hint')),
      primaryLabel: context.tr('back_to_fa'),
      onPrimary: () => Navigator.pop(context),
    );
  }
}
