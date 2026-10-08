import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/craft_categories.dart';
import '../../../../core/localization/tr.dart';
import '../../../../core/shared_models/artisan_profile_model.dart';
import '../state/artisan_profile_provider.dart';
import '../state/auth_provider.dart';
import '../widgets/craft_name.dart';
import '../widgets/profile_avatar_widget.dart';
import '../widgets/profile_form_parts.dart';
import '../widgets/profile_photo_picker.dart';
import 'profile_updated_screen.dart';

// I05 Edit Artisan Profile (+ saving, save failed, offline, discard states)
class EditArtisanProfileScreen extends StatefulWidget {
  final ArtisanProfileModel profile;
  const EditArtisanProfileScreen({super.key, required this.profile});

  @override
  State<EditArtisanProfileScreen> createState() => _EditArtisanProfileScreenState();
}

class _EditArtisanProfileScreenState extends State<EditArtisanProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _about;
  late final TextEditingController _location;
  String? _craftType;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _name = TextEditingController(text: p.displayName)..addListener(_refresh);
    _about = TextEditingController(text: p.about)..addListener(_refresh);
    _location = TextEditingController(text: p.location)..addListener(_refresh);
    _craftType = p.craftType.isEmpty ? null : p.craftType;
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    _name.dispose();
    _about.dispose();
    _location.dispose();
    super.dispose();
  }

  bool get _hasChanges {
    final p = widget.profile;
    return _name.text.trim() != p.displayName ||
        _about.text.trim() != p.about ||
        _location.text.trim() != p.location ||
        (_craftType ?? '') != p.craftType;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final updated = widget.profile.copyWith(
      displayName: _name.text.trim(),
      craftType: _craftType,
      about: _about.text.trim(),
      location: _location.text.trim(),
    );
    final auth = context.read<AuthProvider>();
    final result = await context.read<ArtisanProfileProvider>().save(updated);
    if (!mounted) return;
    if (result == ProfileSaveResult.saved) await auth.reloadCurrentUser();
    if (!mounted) return;

    switch (result) {
      case ProfileSaveResult.saved:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => ProfileUpdatedScreen(artisanId: updated.artisanUid)),
        );
      case ProfileSaveResult.failed:
        _showRetryDialog(
          icon: Icons.error_outline_rounded,
          color: AppColors.error,
          title: context.tr('save_failed_title'),
          message: context.tr('save_failed_body'),
        );
      case ProfileSaveResult.offline:
        _showRetryDialog(
          icon: Icons.wifi_off_rounded,
          color: AppColors.secondary,
          title: context.tr('offline_title'),
          message: context.tr('offline_body'),
        );
    }
  }

  Future<void> _showRetryDialog({
    required IconData icon,
    required Color color,
    required String title,
    required String message,
  }) async {
    final retry = await showChoiceDialog(
      context,
      icon: icon,
      iconColor: color,
      title: title,
      message: message,
      filledLabel: context.tr('try_again'),
      textLabel: context.tr('keep_editing'),
    );
    if (retry == true && mounted) _save();
  }

  Future<bool> _confirmDiscard() async {
    // keep editing is the filled (safe) button, discard is the text one
    final keep = await showChoiceDialog(
      context,
      icon: Icons.warning_amber_rounded,
      iconColor: AppColors.secondary,
      title: context.tr('discard_title'),
      message: context.tr('discard_body'),
      filledLabel: context.tr('keep_editing'),
      textLabel: context.tr('discard'),
      textColor: AppColors.error,
    );
    return keep == false;
  }

  @override
  Widget build(BuildContext context) {
    final saving = context.watch<ArtisanProfileProvider>().isSaving;
    final aboutLength = _about.text.trim().length;
    // first letter of what is typed, or of the saved name while the field is empty
    final avatarName = _name.text.trim().isNotEmpty ? _name.text.trim() : widget.profile.displayName;

    return PopScope(
      canPop: !_hasChanges || saving,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final navigator = Navigator.of(context);
        if (await _confirmDiscard()) navigator.pop();
      },
      child: Scaffold(
        appBar: AppBar(title: Text(context.tr('edit_title'))),
        body: Stack(
          children: [
            Form(
              key: _formKey,
              child: SafeArea(
                top: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                        children: [
                          FormSectionTitle(context.tr('sec_photo')),
                          Row(
                            children: [
                              ProfileAvatarWidget(
                                  name: avatarName, radius: 30, uid: widget.profile.artisanUid),
                              const SizedBox(width: 14),
                              // saved on its own, not by Save Changes (DEVIATIONS DV6)
                              Expanded(
                                child: ProfilePhotoButton(uid: widget.profile.artisanUid),
                              ),
                            ],
                          ),

                          FormSectionTitle(context.tr('sec_basic')),
                          LabelledField(
                            label: context.tr('label_artisan_name'),
                            child: TextFormField(
                              controller: _name,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                hintText: context.tr('hint_artisan_name'),
                                prefixIcon: const Icon(Icons.person_outline,
                                    color: AppColors.textSecondary),
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
                                prefixIcon:
                                    Icon(Icons.palette_outlined, color: AppColors.textSecondary),
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
                              controller: _about,
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
                              controller: _location,
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
                        ],
                      ),
                    ),

                    // save stays at the bottom so it is always in reach
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                      child: ElevatedButton(
                        onPressed: (_hasChanges && !saving) ? _save : null,
                        child: Text(context.tr('save_changes')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (saving)
              Container(
                color: AppColors.background,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 56,
                      height: 56,
                      child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 4),
                    ),
                    const SizedBox(height: 24),
                    Text(context.tr('saving_title'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Text(context.tr('saving_sub'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
