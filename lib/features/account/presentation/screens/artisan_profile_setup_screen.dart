import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/craft_categories.dart';
import '../../../../core/shared_models/artisan_profile_model.dart';
import '../state/auth_provider.dart';

/// I05 first-time setup - hi-fi "Complete Your Artisan Profile" (FR1).
/// CREATES artisanProfiles/{uid}. Profile photo is added later in
/// I05 Manage once Cloud Storage is enabled (decision T6).
class ArtisanProfileSetupScreen extends StatefulWidget {
  const ArtisanProfileSetupScreen({super.key});

  @override
  State<ArtisanProfileSetupScreen> createState() => _ArtisanProfileSetupScreenState();
}

class _ArtisanProfileSetupScreenState extends State<ArtisanProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _aboutController = TextEditingController();
  final _locationController = TextEditingController();
  String? _craftType;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().currentUser;
    _nameController.text = user?.displayName ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _aboutController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final uid = auth.currentUser!.uid;
    await auth.completeArtisanSetup(ArtisanProfileModel(
      artisanUid: uid,
      displayName: _nameController.text.trim(),
      craftType: _craftType!,
      about: _aboutController.text.trim(),
      location: _locationController.text.trim(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Complete Your Artisan Profile')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text('Tell buyers about your craft and story.',
                  style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 20),
              const _SectionTitle('Basic Information'),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Artisan Name'),
                textInputAction: TextInputAction.next,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Please enter your artisan name' : null,
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                initialValue: _craftType,
                decoration: const InputDecoration(labelText: 'Craft Type'),
                items: CraftCategories.all
                    .map((c) => DropdownMenuItem(value: c.key, child: Text(c.label)))
                    .toList(),
                onChanged: (v) => setState(() => _craftType = v),
                validator: (v) => v == null ? 'Please choose your craft type' : null,
              ),
              const SizedBox(height: 20),
              const _SectionTitle('About My Craft'),
              TextFormField(
                controller: _aboutController,
                maxLines: 4,
                decoration: const InputDecoration(
                    hintText: 'Tell us about your craft, materials and inspiration.'),
                validator: (v) => (v == null || v.trim().length < 10)
                    ? 'Please write at least a short sentence (10+ characters)'
                    : null,
              ),
              const SizedBox(height: 20),
              const _SectionTitle('Location'),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(hintText: 'e.g. Colombo, Sri Lanka'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Please enter your location' : null,
              ),
              if (auth.errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(auth.errorMessage!, style: const TextStyle(color: AppColors.error)),
              ],
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: auth.isLoading ? null : _save,
                child: auth.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: AppColors.onPrimary))
                    : const Text('Save Profile'),
              ),
              TextButton(onPressed: auth.logout, child: const Text('Sign out')),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(text,
          style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary)),
    );
  }
}
