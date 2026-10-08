import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ProfileAvatarWidget extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final VoidCallback? onCameraTap;

  const ProfileAvatarWidget({
    Key? key,
    this.imageUrl,
    required this.name,
    this.onCameraTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: AppColors.secondaryLight,
            backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
            child: imageUrl == null
                ? Text(
                    name.isNotEmpty ? name[0].toUpperCase() : 'H',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  )
                : null,
          ),
          if (onCameraTap != null)
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: onCameraTap,
                child: const CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.camera_alt, size: 16, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
