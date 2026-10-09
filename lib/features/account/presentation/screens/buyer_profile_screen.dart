import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/shared_models/user_model.dart';
import '../../../discovery/presentation/screens/favorites_screen.dart';
import '../state/auth_provider.dart';
import '../widgets/profile_avatar_widget.dart';
import 'accept_support_invitation_screen.dart';
import 'buyer_account_details_screen.dart';
import 'language_selection_screen.dart';

/// Buyer-only profile content. The shell owns the bottom navigation.
class BuyerProfileScreen extends StatelessWidget {
  const BuyerProfileScreen(
      {super.key,
      required this.user,
      required this.onSignOut,
      this.onSwitchContext});

  final UserModel user;
  final VoidCallback onSignOut;
  final VoidCallback? onSwitchContext;

  void _open(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    void editProfile() => _open(context, BuyerAccountDetailsScreen(user: user));
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              children: [
                ProfileAvatarWidget(
                    name: user.displayName,
                    uid: user.uid,
                    imageUrl: user.photoUrl,
                    onCameraTap: editProfile),
                const SizedBox(height: 16),
                Text(user.displayName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 23, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(user.email,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 12),
                Center(
                    child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                  decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: .09),
                      borderRadius: BorderRadius.circular(30)),
                  child: const Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.shopping_cart_outlined,
                        size: 18, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text('Buyer',
                        style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600)),
                  ]),
                )),
                const SizedBox(height: 16),
                Center(
                    child: SizedBox(
                        width: 220,
                        child: OutlinedButton.icon(
                          onPressed: editProfile,
                          icon: const Icon(Icons.edit_outlined, size: 20),
                          label: const Text('Edit profile'),
                          style: OutlinedButton.styleFrom(
                              shape: const StadiumBorder()),
                        ))),
                const SizedBox(height: 24),
                _Section(title: 'My shopping', children: [
                  _Entry(
                      icon: Icons.location_on_outlined,
                      title: 'Saved addresses',
                      subtitle: 'Manage your delivery address',
                      onTap: () => _open(
                          context,
                          BuyerAccountDetailsScreen(
                              user: user, address: true))),
                  _Entry(
                      icon: Icons.favorite_border,
                      title: 'Wishlist',
                      subtitle: 'Your favourite handmade finds',
                      onTap: () => _open(context, const FavoritesScreen())),
                  _Entry(
                      icon: Icons.chat_bubble_outline,
                      title: 'My reviews',
                      subtitle: 'View your product reviews',
                      onTap: () =>
                          _open(context, BuyerReviewsScreen(userId: user.uid))),
                ]),
                _Section(title: 'Preferences', children: [
                  _Entry(
                      icon: Icons.language,
                      title: 'Language',
                      subtitle: {
                            'en': 'English',
                            'si': 'Ã Â·Æ’Ã Â·â€™Ã Â¶â€šÃ Â·â€žÃ Â¶Â½',
                            'ta': 'Ã Â®Â¤Ã Â®Â®Ã Â®Â¿Ã Â®Â´Ã Â¯Â'
                          }[user.preferredLanguage] ??
                          'English',
                      onTap: () => _open(context,
                          const LanguageSelectionScreen(fromProfile: true))),
                  _Entry(
                      icon: Icons.notifications_none,
                      title: 'Notifications',
                      subtitle: 'Order updates and offers',
                      onTap: () => _open(
                          context,
                          const BuyerInformationScreen(
                              title: 'Notifications',
                              items: {
                                'Order updates':
                                    'Push notifications are not available yet. Check your orders in the Orders tab.',
                                'Offers':
                                    'Explore Home and Search to discover handmade products from local artisans.'
                              }))),
                  _Entry(
                      icon: Icons.verified_user_outlined,
                      title: 'Account & security',
                      subtitle: 'Password and account settings',
                      onTap: () => _open(
                          context, BuyerSecurityScreen(email: user.email))),
                ]),
                _Section(title: 'Community & support', children: [
                  _Entry(
                      icon: Icons.handshake_outlined,
                      title: 'Accept support invitation',
                      subtitle: 'Help an artisan using a code',
                      onTap: () => _open(
                          context, const AcceptSupportInvitationScreen())),
                  _Entry(
                      icon: Icons.swap_horiz,
                      title: 'Switch context',
                      subtitle: 'Buyer, artisan or supporter',
                      onTap: onSwitchContext ??
                          () => _open(
                              context,
                              const BuyerInformationScreen(
                                  title: 'Switch context',
                                  items: {
                                    'Your buyer account':
                                        'You are currently shopping as a buyer.',
                                    'Supporting an artisan':
                                        'Accept a support invitation from an artisan to add a supporter context. Available contexts will then appear here.'
                                  }))),
                  _Entry(
                      icon: Icons.help_outline,
                      title: 'Help & support',
                      subtitle: 'Get help with your orders',
                      onTap: () => _open(
                          context,
                          const BuyerInformationScreen(
                              title: 'Help & support',
                              items: {
                                'How do I save a product?':
                                    'Tap the heart on a product. Find your saved items in Profile Ã¢â€ â€™ Wishlist.',
                                'How do I update my delivery details?':
                                    'Open Profile Ã¢â€ â€™ Saved addresses to save your default delivery address. Check the address before placing each order.',
                                'How can I help an artisan?':
                                    'Ask the artisan for a support invitation code, then choose Accept support invitation on your profile.',
                                'How do I reset my password?':
                                    'Open Account & security and request a password reset email.',
                              }))),
                ]),
                OutlinedButton.icon(
                    onPressed: onSignOut,
                    icon: const Icon(Icons.logout, size: 20),
                    label: const Text('Sign out'),
                    style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});
  final String title;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 18),
        shape: RoundedRectangleBorder(
            side: const BorderSide(color: AppColors.border),
            borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(18, 17, 18, 6),
              child: Text(title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700))),
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0)
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: Divider(height: 1, color: AppColors.divider)),
            children[i],
          ],
          const SizedBox(height: 6),
        ]),
      );
}

class _Entry extends StatelessWidget {
  const _Entry(
      {required this.icon,
      required this.title,
      required this.subtitle,
      required this.onTap});
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        leading: Icon(icon, color: AppColors.primary, size: 27),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        subtitle: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(subtitle,
                style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.4))),
        trailing: const Icon(Icons.chevron_right, size: 22),
        onTap: onTap,
      );
}

class BuyerSecurityScreen extends StatefulWidget {
  const BuyerSecurityScreen({super.key, required this.email});
  final String email;
  @override
  State<BuyerSecurityScreen> createState() => _BuyerSecurityScreenState();
}

class _BuyerSecurityScreenState extends State<BuyerSecurityScreen> {
  bool _sending = false;
  String? _message;
  Future<void> _reset() async {
    setState(() {
      _sending = true;
      _message = null;
    });
    final auth = context.read<AuthProvider>();
    final success = await auth.sendPasswordReset(widget.email);
    if (!mounted) return;
    setState(() {
      _sending = false;
      _message = success
          ? 'Password reset instructions sent. Check your email.'
          : auth.errorMessage ?? 'Could not send the email. Please try again.';
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Account & security')),
        body: ListView(padding: const EdgeInsets.all(20), children: [
          const Text('Account email',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(widget.email),
          const SizedBox(height: 24),
          const Text(
              'We will email you a link to securely reset your password.'),
          const SizedBox(height: 16),
          ElevatedButton(
              onPressed: _sending ? null : _reset,
              child: Text(
                  _sending ? 'SendingÃ¢â‚¬Â¦' : 'Send password reset email')),
          if (_message != null)
            Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Semantics(liveRegion: true, child: Text(_message!))),
        ]),
      );
}

class BuyerInformationScreen extends StatelessWidget {
  const BuyerInformationScreen(
      {super.key, required this.title, required this.items});
  final String title;
  final Map<String, String> items;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(title)),
        body: ListView(padding: const EdgeInsets.all(20), children: [
          for (final item in items.entries)
            Card(
                child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.key,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 17)),
                          const SizedBox(height: 10),
                          Text(item.value, style: const TextStyle(height: 1.6)),
                        ]))),
        ]),
      );
}
