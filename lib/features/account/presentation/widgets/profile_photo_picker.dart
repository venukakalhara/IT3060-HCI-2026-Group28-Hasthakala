import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/tr.dart';
import '../../data/datasources/profile_photo_remote_datasource.dart';

// "Change Photo" / "Add Photo" button for the profile forms.
// The photo is saved straight away, on its own, so it never touches the
// form's Save button or its unsaved-changes check.
class ProfilePhotoButton extends StatefulWidget {
  final String uid;
  final CrossAxisAlignment alignment;
  const ProfilePhotoButton({
    super.key,
    required this.uid,
    this.alignment = CrossAxisAlignment.start,
  });

  @override
  State<ProfilePhotoButton> createState() => _ProfilePhotoButtonState();
}

class _ProfilePhotoButtonState extends State<ProfilePhotoButton> {
  ProfilePhotoRemoteDataSource? _source;
  late final Stream<Uint8List?> _photo;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    if (Firebase.apps.isEmpty) {
      _photo = Stream.value(null);
    } else {
      _source = ProfilePhotoRemoteDataSource();
      _photo = _source!.watch(widget.uid);
    }
  }

  Future<void> _choose(bool hasPhoto) async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 16),
              Text(ctx.tr('photo_sheet_title'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              _SheetOption(
                icon: Icons.photo_library_outlined,
                label: ctx.tr('photo_gallery'),
                onTap: () => Navigator.pop(ctx, 'gallery'),
              ),
              _SheetOption(
                icon: Icons.photo_camera_outlined,
                label: ctx.tr('photo_camera'),
                onTap: () => Navigator.pop(ctx, 'camera'),
              ),
              if (hasPhoto)
                _SheetOption(
                  icon: Icons.delete_outline_rounded,
                  label: ctx.tr('photo_remove'),
                  color: AppColors.error,
                  onTap: () => Navigator.pop(ctx, 'remove'),
                ),
            ],
          ),
        ),
      ),
    );
    if (choice == null || !mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    final text = {
      'saved': context.tr('photo_saved'),
      'removed': context.tr('photo_removed'),
      'offline': context.tr('photo_offline'),
      'failed': context.tr('photo_failed'),
      'big': context.tr('photo_too_big'),
      'busy': context.tr('photo_uploading'),
    };

    if (choice == 'remove') {
      setState(() => _busy = true);
      final result = await _source!.remove(widget.uid);
      if (!mounted) return;
      setState(() => _busy = false);
      messenger.showSnackBar(SnackBar(
          content: Text(result == PhotoSaveResult.saved
              ? text['removed']!
              : text[result.name]!)));
      return;
    }

    // small avatar only - shrunk and compressed by the picker
    XFile? file;
    try {
      file = await ImagePicker().pickImage(
        source: choice == 'camera' ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 320,
        maxHeight: 320,
        imageQuality: 70,
      );
    } catch (_) {
      file = null;
      messenger.showSnackBar(SnackBar(content: Text(text['failed']!)));
    }
    if (file == null || !mounted) return;

    final bytes = await file.readAsBytes();
    // base64 makes it about a third bigger
    if (bytes.length * 4 / 3 > ProfilePhotoRemoteDataSource.maxChars) {
      messenger.showSnackBar(SnackBar(content: Text(text['big']!)));
      return;
    }

    setState(() => _busy = true);
    messenger.showSnackBar(SnackBar(content: Text(text['busy']!)));
    final result = await _source!.save(widget.uid, bytes);
    if (!mounted) return;
    setState(() => _busy = false);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(content: Text(text[result.name]!)));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Uint8List?>(
      stream: _photo,
      builder: (context, snapshot) {
        final hasPhoto = snapshot.data != null;
        return Column(
          crossAxisAlignment: widget.alignment,
          children: [
            OutlinedButton.icon(
              onPressed:
                  _busy || _source == null ? null : () => _choose(hasPhoto),
              icon: _busy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.primary))
                  : const Icon(Icons.photo_camera_outlined, size: 20),
              label: Text(context.tr(hasPhoto ? 'photo_change' : 'photo_add')),
              style: OutlinedButton.styleFrom(minimumSize: const Size(0, 44)),
            ),
            const SizedBox(height: 6),
            Text(
              context.tr('photo_hint'),
              textAlign: widget.alignment == CrossAxisAlignment.center
                  ? TextAlign.center
                  : TextAlign.start,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 13),
            ),
          ],
        );
      },
    );
  }
}

class _SheetOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _SheetOption({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(label,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: color == AppColors.error
                              ? color
                              : AppColors.textPrimary)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
