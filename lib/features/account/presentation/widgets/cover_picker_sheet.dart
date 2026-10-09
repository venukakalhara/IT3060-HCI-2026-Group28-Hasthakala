import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/tr.dart';
import '../state/artisan_profile_provider.dart';
import 'profile_covers.dart';

// small button that sits on the cover in My Artisan Profile
class ChangeCoverButton extends StatelessWidget {
  final VoidCallback onPressed;
  const ChangeCoverButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface.withValues(alpha: 0.92),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onPressed,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 40),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.wallpaper_rounded, size: 18, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(context.tr('cover_change'),
                    style: const TextStyle(
                        color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// opens the picker, saves the choice straight away and says how it went
Future<void> showCoverPicker(BuildContext context,
    {required String uid, required String? current}) async {
  final picked = await showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (_) => _CoverSheet(current: coverFor(current).key),
  );
  if (picked == null || picked == coverFor(current).key || !context.mounted) return;

  final messenger = ScaffoldMessenger.of(context);
  final saved = context.tr('cover_saved');
  final offline = context.tr('cover_offline');
  final failed = context.tr('cover_failed');
  messenger.showSnackBar(SnackBar(content: Text(context.tr('cover_saving'))));

  final result = await context.read<ArtisanProfileProvider>().saveCoverStyle(uid, picked);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(SnackBar(
    content: Text(switch (result) {
      ProfileSaveResult.saved => saved,
      ProfileSaveResult.offline => offline,
      ProfileSaveResult.failed => failed,
    }),
  ));
}

class _CoverSheet extends StatelessWidget {
  final String current;
  const _CoverSheet({required this.current});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(context.tr('cover_title'),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(context.tr('cover_sub'),
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 18),
            Flexible(
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 12,
                childAspectRatio: 1.25,
                children: [
                  for (final c in profileCovers)
                    _CoverOption(
                      cover: c,
                      selected: c.key == current,
                      onTap: () => Navigator.pop(context, c.key),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CoverOption extends StatelessWidget {
  final ProfileCover cover;
  final bool selected;
  final VoidCallback onTap;

  const _CoverOption({required this.cover, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: context.tr(cover.nameKey),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selected ? AppColors.primary : AppColors.border,
                    width: selected ? 3 : 1,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CoverArt(cover: cover, small: true),
                    if (selected)
                      const Positioned(
                        right: 6,
                        bottom: 6,
                        child: CircleAvatar(
                          radius: 13,
                          backgroundColor: AppColors.accent,
                          child: Icon(Icons.check_rounded, size: 16, color: AppColors.onPrimary),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              context.tr(cover.nameKey),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
