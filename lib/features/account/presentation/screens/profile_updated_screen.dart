import 'package:flutter/material.dart';

import '../../../../core/localization/tr.dart';
import '../../../discovery/presentation/screens/public_artisan_profile_screen.dart';
import '../widgets/profile_preview_card.dart';
import '../widgets/status_screen.dart';

// I05 Profile updated
class ProfileUpdatedScreen extends StatelessWidget {
  final String artisanId;
  const ProfileUpdatedScreen({super.key, required this.artisanId});

  @override
  Widget build(BuildContext context) {
    return StatusScreen(
      icon: Icons.check_rounded,
      // shows the saved profile so the change is easy to see
      header: ProfilePreviewCard(artisanId: artisanId),
      title: context.tr('updated_title'),
      message: context.tr('updated_body'),
      primaryLabel: context.tr('view_my_profile'),
      onPrimary: () => Navigator.pop(context),
      secondaryLabel: context.tr('preview_public_profile'),
      onSecondary: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => PublicArtisanProfileScreen(artisanId: artisanId)),
      ),
    );
  }
}
