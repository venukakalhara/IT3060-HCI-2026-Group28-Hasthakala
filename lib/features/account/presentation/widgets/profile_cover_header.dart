import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'profile_avatar_widget.dart';
import 'profile_covers.dart';

// card with the cover (photo or one of the colour covers), the avatar on its edge,
// then the name and a small chip. Used on Profile and My Artisan Profile.
class ProfileCoverHeader extends StatelessWidget {
  final String name;
  final String? photoUrl;
  final Widget? chip;
  final List<Widget> details;
  final String? coverStyle;
  final Widget? coverAction; // e.g. the Change cover button, top right
  final String? uid; // shows the saved profile photo when given

  const ProfileCoverHeader({
    super.key,
    required this.name,
    this.photoUrl,
    this.chip,
    this.details = const [],
    this.coverStyle,
    this.coverAction,
    this.uid,
  });

  static const _coverHeight = 118.0;
  static const _avatarRadius = 40.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          SizedBox(
            height: _coverHeight + _avatarRadius + 4,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: _coverHeight,
                  child: CoverArt(cover: coverFor(coverStyle)),
                ),
                // fade the bottom of the photo into the card
                Positioned(
                  left: 0,
                  right: 0,
                  top: _coverHeight - 40,
                  height: 40,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.surface.withValues(alpha: 0),
                          AppColors.surface,
                        ],
                      ),
                    ),
                  ),
                ),
                if (coverAction != null) Positioned(top: 8, right: 8, child: coverAction!),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ProfileAvatarWidget(
                    name: name,
                    imageUrl: photoUrl,
                    radius: _avatarRadius,
                    uid: uid,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
            child: Column(
              children: [
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
                ),
                if (chip != null) ...[const SizedBox(height: 8), chip!],
                for (final d in details) ...[const SizedBox(height: 6), d],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// small rounded label, e.g. "Batik Artisan" or "Buyer"
class ProfileChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const ProfileChip({
    super.key,
    required this.icon,
    required this.label,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
