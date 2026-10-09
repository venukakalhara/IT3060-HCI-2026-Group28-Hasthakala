import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/tr.dart';
import '../../../../core/shared_models/artisan_profile_model.dart';
import '../../../discovery/presentation/screens/public_artisan_profile_screen.dart';
import '../state/artisan_profile_provider.dart';
import '../state/auth_provider.dart';
import '../widgets/cover_picker_sheet.dart';
import '../widgets/craft_name.dart';
import '../widgets/profile_cover_header.dart';
import '../widgets/profile_covers.dart';
import 'edit_artisan_profile_screen.dart';

// I05 My Artisan Profile
class MyArtisanProfileScreen extends StatefulWidget {
  const MyArtisanProfileScreen({super.key});

  @override
  State<MyArtisanProfileScreen> createState() => _MyArtisanProfileScreenState();
}

class _MyArtisanProfileScreenState extends State<MyArtisanProfileScreen> {
  late final Stream<ArtisanProfileModel?> _profile;
  late final String _uid;

  @override
  void initState() {
    super.initState();
    _uid = context.read<AuthProvider>().currentUser!.uid;
    _profile = context.read<ArtisanProfileProvider>().watchProfile(_uid);
  }

  // e.g. "October 2026" in the chosen language
  String _monthYear(BuildContext context, DateTime date) {
    try {
      return DateFormat.yMMMM(Localizations.localeOf(context).languageCode).format(date);
    } catch (_) {
      return DateFormat.yMMMM('en').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('profile_my_artisan'))),
      body: StreamBuilder<ArtisanProfileModel?>(
        stream: _profile,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_off_rounded, size: 48, color: AppColors.textSecondary),
                    const SizedBox(height: 12),
                    Text(context.tr('profile_load_error'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 15)),
                  ],
                ),
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          final p = snapshot.data!;

          return SafeArea(
            top: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                    children: [
                      ArtisanCoverStyle(
                        uid: _uid,
                        builder: (context, style) => ProfileCoverHeader(
                        coverStyle: style,
                        uid: _uid,
                        coverAction: ChangeCoverButton(
                          onPressed: () => showCoverPicker(context, uid: _uid, current: style),
                        ),
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
                          const SizedBox(height: 2),
                          // verified is set by an admin, the artisan can't change it
                          p.verified
                              ? ProfileChip(
                                  icon: Icons.verified_rounded,
                                  label: context.tr('profile_verified'),
                                  color: AppColors.accent,
                                )
                              : ProfileChip(
                                  icon: Icons.hourglass_empty_rounded,
                                  label: context.tr('profile_not_verified'),
                                  color: AppColors.textSecondary,
                                ),
                        ],
                      ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.info_outline_rounded,
                              size: 16, color: AppColors.textSecondary),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(context.tr('profile_buyers_see'),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: AppColors.textSecondary, fontSize: 13)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _InfoCard(
                        icon: Icons.auto_stories_outlined,
                        title: context.tr('about_my_craft'),
                        child: Text(
                          p.about.isNotEmpty ? p.about : context.tr('profile_about_empty'),
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 15, height: 1.5),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _InfoCard(
                        icon: Icons.event_outlined,
                        title: context.tr('profile_member_since'),
                        child: Text(_monthYear(context, p.createdAt),
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 15)),
                      ),
                      const SizedBox(height: 12),
                      _InfoCard(
                        icon: Icons.update_rounded,
                        title: context.tr('profile_last_updated'),
                        child: Text(_monthYear(context, p.updatedAt),
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 15)),
                      ),
                    ],
                  ),
                ),

                // main actions at the bottom, like the other screens
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.edit_outlined),
                        label: Text(context.tr('edit_profile')),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => EditArtisanProfileScreen(profile: p)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.visibility_outlined),
                        label: Text(context.tr('preview_public_profile')),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => PublicArtisanProfileScreen(artisanId: _uid)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// card with a tinted icon box and a title, same look as the profile tab
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _InfoCard({required this.icon, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.primary, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 2),
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 4),
                child,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
