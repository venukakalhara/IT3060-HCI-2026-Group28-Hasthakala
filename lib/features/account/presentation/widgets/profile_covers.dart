import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../state/artisan_profile_provider.dart';

// the covers an artisan can pick (saved as artisanProfiles.coverStyle).
// only colours from our palette, so profiles still look like the app.
class ProfileCover {
  final String key;
  final String nameKey; // text key in app_strings
  final String? image;
  final List<Color> colors;
  final Color wordColor; // colour of the HASTHAKALA word on plain covers

  const ProfileCover({
    required this.key,
    required this.nameKey,
    this.image,
    this.colors = const [],
    this.wordColor = AppColors.onPrimary,
  });
}

const profileCovers = [
  ProfileCover(key: 'photo', nameKey: 'cover_photo', image: 'assets/images/profile_cover.jpg'),
  ProfileCover(key: 'collage', nameKey: 'cover_collage', image: 'assets/images/crafts_banner.jpg'),
  ProfileCover(
      key: 'clay', nameKey: 'cover_clay', colors: [AppColors.primary, AppColors.primaryDark]),
  ProfileCover(
      key: 'sunset', nameKey: 'cover_sunset', colors: [AppColors.primary, AppColors.secondary]),
  ProfileCover(
      key: 'paddy', nameKey: 'cover_paddy', colors: [AppColors.accent, AppColors.secondary]),
  ProfileCover(
    key: 'linen',
    nameKey: 'cover_linen',
    colors: [AppColors.background, AppColors.secondaryLight],
    wordColor: AppColors.primary,
  ),
];

// unknown or missing style -> the default photo
ProfileCover coverFor(String? key) =>
    profileCovers.firstWhere((c) => c.key == key, orElse: () => profileCovers.first);

// draws one cover: the photo, or a gradient with faint petals and the wordmark
class CoverArt extends StatelessWidget {
  final ProfileCover cover;
  final bool small; // smaller wordmark for the picker
  const CoverArt({super.key, required this.cover, this.small = false});

  @override
  Widget build(BuildContext context) {
    if (cover.image != null) return Image.asset(cover.image!, fit: BoxFit.cover);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: cover.colors,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            right: -10,
            top: -10,
            child: Opacity(
              opacity: 0.25,
              child: Image.asset(
                'assets/images/petal_corner_top.png',
                width: small ? 70 : 130,
                color: cover.wordColor,
                colorBlendMode: BlendMode.srcIn,
              ),
            ),
          ),
          Positioned(
            left: small ? 10 : 18,
            top: small ? 10 : 22,
            child: Text(
              'HASTHAKALA',
              style: TextStyle(
                color: cover.wordColor,
                fontSize: small ? 12 : 22,
                fontWeight: FontWeight.w700,
                letterSpacing: small ? 1.2 : 2.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// listens to the artisan's cover style and rebuilds when it changes
class ArtisanCoverStyle extends StatefulWidget {
  final String uid;
  final Widget Function(BuildContext context, String? style) builder;
  const ArtisanCoverStyle({super.key, required this.uid, required this.builder});

  @override
  State<ArtisanCoverStyle> createState() => _ArtisanCoverStyleState();
}

class _ArtisanCoverStyleState extends State<ArtisanCoverStyle> {
  late final Stream<String?> _style;

  @override
  void initState() {
    super.initState();
    _style = context.read<ArtisanProfileProvider>().watchCoverStyle(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String?>(
      stream: _style,
      builder: (context, snapshot) => widget.builder(context, snapshot.data),
    );
  }
}
