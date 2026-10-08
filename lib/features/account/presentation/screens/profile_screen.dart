import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../state/auth_provider.dart';
import '../widgets/profile_avatar_widget.dart';
import 'family_support_settings_screen.dart';

/// Assigned to: WANIGATHUNGA Y. J.
/// Branch: feature/account-support
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Account & Settings'),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ProfileAvatarWidget(
            name: user?.displayName ?? 'Hasthakala Artisan',
            imageUrl: user?.photoUrl,
            onCameraTap: () {},
          ),
          const SizedBox(height: 16),
          Text(
            user?.displayName ?? 'Traditional Craftsman',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            user?.email ?? 'artisan@hasthakala.lk',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.badge_outlined, color: AppColors.secondary),
            title: const Text('Started as'),
            trailing: Text(
                (user?.startedAsSeller ?? false) ? 'SELLER' : 'BUYER',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: const Icon(Icons.people_outline, color: AppColors.accent),
            title: const Text('Family Support & Permissions'),
            subtitle: const Text('Delegated management for elders'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FamilySupportSettingsScreen(
                    elderArtisanUid: user?.uid ?? 'artisan123',
                  ),
                ),
              );
            },
          ),
          if (auth.availableContextCount > 1)
            ListTile(
              leading: const Icon(Icons.swap_horiz, color: AppColors.primary),
              title: const Text('Switch context'),
              subtitle: const Text('Continue as buyer, artisan or supporter'),
              onTap: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
                auth.switchContext();
              },
            ),
          const SizedBox(height: 32),
          CustomButton(
            text: 'Sign Out',
            isOutlined: true,
            textColor: AppColors.error,
            backgroundColor: AppColors.error,
            onPressed: () async {
              Navigator.of(context).popUntil((route) => route.isFirst);
              await auth.logout(); // AuthGate then shows the sign-in screen
            },
          ),
        ],
      ),
    );
  }
}
