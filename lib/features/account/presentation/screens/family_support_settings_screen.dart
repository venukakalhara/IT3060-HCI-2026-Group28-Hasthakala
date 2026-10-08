import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../state/family_support_provider.dart';
import '../widgets/permission_toggle_tile.dart';

/// Assigned to: WANIGATHUNGA Y. J.
/// Branch: feature/account-support
class FamilySupportSettingsScreen extends StatefulWidget {
  final String elderArtisanUid;

  const FamilySupportSettingsScreen({Key? key, required this.elderArtisanUid})
      : super(key: key);

  @override
  State<FamilySupportSettingsScreen> createState() => _FamilySupportSettingsScreenState();
}

class _FamilySupportSettingsScreenState extends State<FamilySupportSettingsScreen> {
  final TextEditingController _assistantEmailController = TextEditingController();
  bool _canManageOrders = true;
  bool _canManageListings = true;
  bool _canReplyMessages = true;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FamilySupportProvider(),
      child: Consumer<FamilySupportProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            appBar: const CustomAppBar(title: 'Family Assisted Management'),
            body: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryLight.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, color: AppColors.secondaryDark),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Empower younger family members to help elder artisans photograph crafts, reply to customer chats, and fulfill orders.',
                          style: TextStyle(fontSize: 13, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  label: 'Assistant / Family Member Email',
                  hint: 'assistant@family.lk',
                  controller: _assistantEmailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Delegated Permissions',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                PermissionToggleTile(
                  title: 'Order Status & Dispatching',
                  description: 'Allow family assistant to accept and mark orders as dispatched',
                  value: _canManageOrders,
                  onChanged: (val) => setState(() => _canManageOrders = val),
                ),
                PermissionToggleTile(
                  title: 'Product Catalog & Pricing',
                  description: 'Allow adding photographs and updating inventory stock',
                  value: _canManageListings,
                  onChanged: (val) => setState(() => _canManageListings = val),
                ),
                PermissionToggleTile(
                  title: 'Customer Conversations & Chats',
                  description: 'Allow replying to customer inquiries on behalf of the artisan',
                  value: _canReplyMessages,
                  onChanged: (val) => setState(() => _canReplyMessages = val),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Save Family Permissions',
                  isLoading: provider.isSaving,
                  onPressed: () async {
                    if (_assistantEmailController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter an assistant email')),
                      );
                      return;
                    }

                    final success = await provider.saveAssistedSettings(
                      elderArtisanUid: widget.elderArtisanUid,
                      assistantEmail: _assistantEmailController.text.trim(),
                      canManageOrders: _canManageOrders,
                      canManageListings: _canManageListings,
                      canReplyMessages: _canReplyMessages,
                    );

                    if (success && mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Family assistant permissions granted!')),
                      );
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
