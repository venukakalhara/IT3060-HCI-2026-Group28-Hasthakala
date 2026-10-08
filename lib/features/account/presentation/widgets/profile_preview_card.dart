import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/tr.dart';
import '../../../../core/shared_models/artisan_profile_model.dart';
import '../state/artisan_profile_provider.dart';
import 'craft_name.dart';
import 'profile_cover_header.dart';
import 'profile_covers.dart';

// small preview of the artisan profile with a green tick on the corner.
// used on "Artisan profile created!" and "Profile updated".
// shows the plain green tick until the profile has loaded.
class ProfilePreviewCard extends StatefulWidget {
  final String artisanId;
  const ProfilePreviewCard({super.key, required this.artisanId});

  @override
  State<ProfilePreviewCard> createState() => _ProfilePreviewCardState();
}

class _ProfilePreviewCardState extends State<ProfilePreviewCard> {
  late final Stream<ArtisanProfileModel?> _profile;

  @override
  void initState() {
    super.initState();
    _profile = context.read<ArtisanProfileProvider>().watchProfile(widget.artisanId);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ArtisanProfileModel?>(
      stream: _profile,
      builder: (context, snapshot) {
        final p = snapshot.data;
        if (p == null) return const _Tick(size: 52);

        // padding leaves room for the tick that sits over the corner
        return Padding(
          padding: const EdgeInsets.only(top: 14, right: 8),
          child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 340),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              ArtisanCoverStyle(
                uid: widget.artisanId,
                builder: (context, style) => ProfileCoverHeader(
                coverStyle: style,
                uid: widget.artisanId,
                name: p.displayName,
                photoUrl: p.photoUrl,
                chip: ProfileChip(
                  icon: Icons.palette_outlined,
                  label: context.tr('craft_artisan', {'craft': craftName(context, p.craftType)}),
                ),
                details: [
                  if (p.location.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(p.location,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: AppColors.textSecondary)),
                        ),
                      ],
                    ),
                ],
              ),
              ),
              const Positioned(top: -14, right: -8, child: _Tick(size: 22)),
            ],
          ),
          ),
        );
      },
    );
  }
}

// green tick in a soft ring, same as the Entry/AAuth success screens
class _Tick extends StatelessWidget {
  final double size;
  const _Tick({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(size * 0.2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.accent.withValues(alpha: 0.15),
      ),
      child: CircleAvatar(
        radius: size,
        backgroundColor: AppColors.accent,
        child: Icon(Icons.check_rounded, size: size, color: AppColors.onPrimary),
      ),
    );
  }
}
