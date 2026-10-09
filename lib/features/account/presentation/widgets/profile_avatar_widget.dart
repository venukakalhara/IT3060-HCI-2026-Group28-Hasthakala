import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/datasources/profile_photo_remote_datasource.dart';

// round photo, or the first letter of the name when there is no photo.
// with a uid it also shows the photo saved in profilePhotos/{uid}.
class ProfileAvatarWidget extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final double radius;
  final VoidCallback? onCameraTap;
  final String? uid;

  const ProfileAvatarWidget({
    super.key,
    this.imageUrl,
    required this.name,
    this.radius = 48,
    this.onCameraTap,
    this.uid,
  });

  @override
  Widget build(BuildContext context) {
    if (uid == null || uid!.isEmpty || Firebase.apps.isEmpty) {
      return _build(null);
    }
    return _SavedPhoto(uid: uid!, builder: _build);
  }

  Widget _build(Uint8List? photo) {
    ImageProvider? image;
    if (photo != null) {
      image = MemoryImage(photo);
    } else if (imageUrl != null) {
      image = NetworkImage(imageUrl!);
    }
    final avatar = Container(
      // light ring so the avatar stands out on the cover photo
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.secondaryLight,
        backgroundImage: image,
        child: image == null
            ? Text(
                name.isNotEmpty ? name[0].toUpperCase() : 'H',
                style: TextStyle(
                  fontSize: radius * 0.8,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              )
            : null,
      ),
    );

    if (onCameraTap == null) return avatar;
    return Center(
      child: GestureDetector(
        onTap: onCameraTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            avatar,
            Positioned(
              right: -2,
              bottom: -2,
              child: const CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primary,
                child: Icon(Icons.camera_alt,
                    size: 16, color: AppColors.onPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// keeps one listener per avatar so the photo doesn't flicker on rebuilds
class _SavedPhoto extends StatefulWidget {
  final String uid;
  final Widget Function(Uint8List? photo) builder;
  const _SavedPhoto({required this.uid, required this.builder});

  @override
  State<_SavedPhoto> createState() => _SavedPhotoState();
}

class _SavedPhotoState extends State<_SavedPhoto> {
  late Stream<Uint8List?> _photo;

  @override
  void initState() {
    super.initState();
    _photo = ProfilePhotoRemoteDataSource().watch(widget.uid);
  }

  @override
  void didUpdateWidget(covariant _SavedPhoto oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.uid != widget.uid) {
      _photo = ProfilePhotoRemoteDataSource().watch(widget.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Uint8List?>(
      stream: _photo,
      builder: (context, snapshot) => widget.builder(snapshot.data),
    );
  }
}
