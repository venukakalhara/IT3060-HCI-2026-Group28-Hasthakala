import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/craft_categories.dart';
import '../../../../core/localization/tr.dart';
import '../../../../core/shared_models/artisan_profile_model.dart';
import '../state/auth_provider.dart';
import '../widgets/craft_name.dart';
import '../widgets/profile_avatar_widget.dart';
import '../widgets/profile_form_parts.dart';
import '../widgets/profile_photo_picker.dart';

// I05 Complete Your Artisan Profile (first time) - creates artisanProfiles/{uid}
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
    // only to redraw the avatar letter and the character hint
    _nameController.addListener(_refresh);
    _aboutController.addListener(_refresh);
  }

  void _refresh() => setState(() {});

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
    final aboutLength = _aboutController.text.trim().length;
    final avatarName = _nameController.text.trim().isNotEmpty
        ? _nameController.text.trim()
        : (auth.currentUser?.displayName ?? '');

    return Scaffold(
      appBar: AppBar(title: Text(context.tr('setup_title'))),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  children: [
                    const SizedBox(height: 4),
                    // crafts photo to make the first visit feel welcoming
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: SizedBox(
                        height: 120,
                        child: Image.asset('assets/images/crafts_banner.jpg', fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(context.tr('setup_intro'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 15)),

                    FormSectionTitle(context.tr('sec_photo')),
                    Row(
                      children: [
                        ProfileAvatarWidget(
                            name: avatarName, radius: 30, uid: auth.currentUser?.uid),
                        const SizedBox(width: 14),
                        // saved on its own, not by Save Profile (DEVIATIONS DV6)
                        Expanded(
                          child: auth.currentUser == null
                              ? const SizedBox.shrink()
                              : ProfilePhotoButton(uid: auth.currentUser!.uid),
                        ),
                      ],
                    ),

                    FormSectionTitle(context.tr('sec_basic')),
                    LabelledField(
                      label: context.tr('label_artisan_name'),
                      child: TextFormField(
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          hintText: context.tr('hint_artisan_name'),
                          prefixIcon:
                              const Icon(Icons.person_outline, color: AppColors.textSecondary),
                        ),
                        validator: (v) => context.trMessage(
                            (v == null || v.trim().isEmpty) ? 'Artisan name is required.' : null),
                      ),
                    ),
                    const SizedBox(height: 16),
                    LabelledField(
                      label: context.tr('label_craft'),
                      child: DropdownButtonFormField<String>(
                        initialValue: _craftType,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.palette_outlined, color: AppColors.textSecondary),
                        ),
                        hint: Text(context.tr('hint_craft')),
                        items: CraftCategories.all
                            .map((c) => DropdownMenuItem(
                                value: c.key, child: Text(craftName(context, c.key))))
                            .toList(),
                        onChanged: (v) => setState(() => _craftType = v),
                        validator: (v) =>
                            context.trMessage(v == null ? 'Please select a craft type.' : null),
                      ),
                    ),

                    FormSectionTitle(context.tr('about_my_craft')),
                    LabelledField(
                      label: context.tr('label_about'),
                      helper: aboutLength >= 10
                          ? FieldHint(context.tr('about_ok'), ok: true)
                          : FieldHint(context.tr('about_count', {'count': '$aboutLength'})),
                      child: TextFormField(
                        controller: _aboutController,
                        maxLines: 4,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(hintText: context.tr('hint_about')),
                        validator: (v) => context.trMessage((v == null || v.trim().length < 10)
                            ? 'Please write a short description (10+ characters).'
                            : null),
                      ),
                    ),

                    FormSectionTitle(context.tr('sec_location')),
                    LabelledField(
                      label: context.tr('label_location'),
                      helper: FieldHint(context.tr('location_help'),
                          icon: Icons.lock_outline_rounded),
                      child: TextFormField(
                        controller: _locationController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          hintText: context.tr('hint_location'),
                          prefixIcon: const Icon(Icons.location_on_outlined,
                              color: AppColors.textSecondary),
                        ),
                        validator: (v) => context.trMessage(
                            (v == null || v.trim().isEmpty) ? 'Please enter your location.' : null),
                      ),
                    ),
                    if (auth.errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Text(context.trMessage(auth.errorMessage)!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.error)),
                    ],
                  ],
                ),
              ),

              // save at the bottom like the edit screen, sign out stays small under it
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: auth.isLoading ? null : _save,
                      child: auth.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: AppColors.onPrimary))
                          : Text(context.tr('save_profile')),
                    ),
                    TextButton(onPressed: auth.logout, child: Text(context.tr('sign_out'))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
