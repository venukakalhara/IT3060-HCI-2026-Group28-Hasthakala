import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/tr.dart';
import '../state/auth_provider.dart';
import '../widgets/profile_preview_card.dart';
import '../widgets/status_screen.dart';

// I05 Artisan profile created (first-time artisan)
class ArtisanProfileCreatedScreen extends StatelessWidget {
  const ArtisanProfileCreatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final uid = auth.currentUser?.uid;
    return StatusScreen(
      icon: Icons.check_rounded,
      // preview of what users just made
      header: uid == null ? null : ProfilePreviewCard(artisanId: uid),
      title: context.tr('created_title'),
      message: context.tr('created_body'),
      primaryLabel: context.tr('continue'),
      onPrimary: auth.finishArtisanSetup,
    );
  }
}
