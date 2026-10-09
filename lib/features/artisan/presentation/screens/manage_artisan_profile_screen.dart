import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/craft_categories.dart';
import '../../../../core/shared_models/artisan_profile_model.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../account/presentation/state/auth_provider.dart';
import '../../data/datasources/artisan_profile_datasource.dart';

/// I05 & FR1: Manage Artisan Profile Screen.
/// Supports viewing, editing, and previewing the artisan profile (Nadeesha persona).
/// Follows the locked Firestore schema and rules for artisanProfiles/{artisanUid}.
class ManageArtisanProfileScreen extends StatefulWidget {
  final String? artisanId;

  const ManageArtisanProfileScreen({super.key, this.artisanId});

  @override
  State<ManageArtisanProfileScreen> createState() => _ManageArtisanProfileScreenState();
}

class _ManageArtisanProfileScreenState extends State<ManageArtisanProfileScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _datasource = ArtisanProfileDatasource();

  late TabController _tabController;
  final _nameController = TextEditingController();
  final _aboutController = TextEditingController();
  final _locationController = TextEditingController();
  final _photoUrlController = TextEditingController();

  String? _craftType;
  bool _verified = false;
  bool _isLoading = true;
  bool _isSaving = false;
  ArtisanProfileModel? _existingProfile;

  final List<String> _presetAvatars = [
    'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=400&q=80', // Artisan portrait 1
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400&q=80', // Artisan portrait 2
    'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=400&q=80', // Artisan portrait 3
    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=400&q=80', // Artisan portrait 4
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadProfileData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _aboutController.dispose();
    _locationController.dispose();
    _photoUrlController.dispose();
    super.dispose();
  }

  Future<void> _loadProfileData() async {
    final auth = context.read<AuthProvider>();
    final effectiveUid = widget.artisanId?.isNotEmpty == true
        ? widget.artisanId!
        : (auth.actingArtisanId ?? auth.currentUser?.uid ?? '');

    if (effectiveUid.isEmpty) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final profile = await _datasource.getProfile(effectiveUid);
      if (mounted) {
        setState(() {
          _existingProfile = profile;
          if (profile != null) {
            _nameController.text = profile.displayName;
            _craftType = profile.craftType.isNotEmpty ? profile.craftType : null;
            _aboutController.text = profile.about;
            _locationController.text = profile.location;
            _photoUrlController.text = profile.photoUrl ?? '';
            _verified = profile.verified;
          } else {
            // New artisan setup (FR1) defaults
            _nameController.text = auth.currentUser?.displayName ?? '';
            _photoUrlController.text = auth.currentUser?.photoUrl ?? '';
            _verified = false;
          }
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      _tabController.animateTo(0);
      return;
    }

    final auth = context.read<AuthProvider>();
    final effectiveUid = widget.artisanId?.isNotEmpty == true
        ? widget.artisanId!
        : (auth.actingArtisanId ?? auth.currentUser?.uid ?? '');

    if (effectiveUid.isEmpty) return;

    setState(() => _isSaving = true);

    try {
      final profile = ArtisanProfileModel(
        artisanUid: effectiveUid,
        displayName: _nameController.text.trim(),
        craftType: _craftType ?? 'pottery',
        about: _aboutController.text.trim(),
        location: _locationController.text.trim(),
        photoUrl: _photoUrlController.text.trim().isNotEmpty ? _photoUrlController.text.trim() : null,
        verified: _verified,
        createdAt: _existingProfile?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _datasource.saveProfile(profile);

      if (!mounted) return;

      setState(() {
        _existingProfile = profile;
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Artisan profile saved successfully!'),
          backgroundColor: AppColors.accent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save profile: $e'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showPhotoPickerSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final tempController = TextEditingController(text: _photoUrlController.text);
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Artisan Profile Photo',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Enter image web address or choose a preset portrait:',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: tempController,
                decoration: InputDecoration(
                  hintText: 'https://images.unsplash.com/...',
                  prefixIcon: const Icon(Icons.link, color: AppColors.primary),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.check, color: AppColors.accent),
                    onPressed: () {
                      setState(() {
                        _photoUrlController.text = tempController.text.trim();
                      });
                      Navigator.pop(ctx);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Preset Artisan Portraits',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 70,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _presetAvatars.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, idx) {
                    final url = _presetAvatars[idx];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _photoUrlController.text = url;
                        });
                        Navigator.pop(ctx);
                      },
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _photoUrlController.text == url ? AppColors.primary : AppColors.border,
                            width: 2,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(url),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        appBar: CustomAppBar(title: 'Artisan Profile'),
        body: LoadingIndicator(message: 'Loading artisan profile...'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Artisan Profile'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: const [
            Tab(icon: Icon(Icons.edit_note), text: 'Edit Profile'),
            Tab(icon: Icon(Icons.visibility_outlined), text: 'Buyer Preview'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEditForm(),
          _buildBuyerPreview(),
        ],
      ),
    );
  }

  Widget _buildEditForm() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Header: Avatar & Verified status
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 54,
                  backgroundColor: AppColors.secondaryLight.withValues(alpha: 0.3),
                  backgroundImage: _photoUrlController.text.trim().isNotEmpty
                      ? NetworkImage(_photoUrlController.text.trim())
                      : null,
                  child: _photoUrlController.text.trim().isEmpty
                      ? const Icon(Icons.person, size: 60, color: AppColors.primary)
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: _showPhotoPickerSheet,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Verification badge indicator
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: _verified
                    ? AppColors.accent.withValues(alpha: 0.12)
                    : AppColors.secondary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _verified ? AppColors.accent : AppColors.secondary,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _verified ? Icons.verified : Icons.shield_outlined,
                    color: _verified ? AppColors.accent : AppColors.secondary,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _verified ? 'Verified Master Artisan' : 'Community Artisan',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: _verified ? AppColors.accent : AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Section 1: Basic Information
          _buildSectionHeader('Artisan Identity', Icons.badge_outlined),
          const SizedBox(height: 12),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Artisan / Studio Name *',
              hintText: 'e.g., Nadeesha Traditional Crafts',
              prefixIcon: Icon(Icons.person_outline),
            ),
            textInputAction: TextInputAction.next,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Please enter your artisan name' : null,
          ),
          const SizedBox(height: 14),

          DropdownButtonFormField<String>(
            initialValue: _craftType,
            decoration: const InputDecoration(
              labelText: 'Primary Craft Specialty *',
              prefixIcon: Icon(Icons.category_outlined),
            ),
            items: CraftCategories.all
                .map((c) => DropdownMenuItem(value: c.key, child: Text(c.label)))
                .toList(),
            onChanged: (v) => setState(() => _craftType = v),
            validator: (v) => v == null ? 'Please select your craft specialty' : null,
          ),
          const SizedBox(height: 14),

          TextFormField(
            controller: _locationController,
            decoration: const InputDecoration(
              labelText: 'Workshop Location & District *',
              hintText: 'e.g., Kandy, Central Province',
              prefixIcon: Icon(Icons.location_on_outlined),
            ),
            textInputAction: TextInputAction.next,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Please enter your workshop location' : null,
          ),
          const SizedBox(height: 24),

          // Section 2: Craft Heritage & Story
          _buildSectionHeader('Heritage & Craft Story', Icons.auto_stories_outlined),
          const SizedBox(height: 8),
          const Text(
            'Share your traditional roots, crafting techniques, materials, and family heritage with buyers.',
            style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _aboutController,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText:
                  'e.g. Dedicated to preserving ancient Sri Lankan pottery traditions passed down through four generations. Each item is individually wheel-thrown and wood-fired using organic clay...',
            ),
            validator: (v) => (v == null || v.trim().length < 15)
                ? 'Please share a story of at least 15 characters'
                : null,
          ),
          const SizedBox(height: 24),

          // Section 3: Profile Photo URL
          _buildSectionHeader('Profile Photo URL', Icons.photo_outlined),
          const SizedBox(height: 8),
          TextFormField(
            controller: _photoUrlController,
            decoration: InputDecoration(
              hintText: 'https://...',
              prefixIcon: const Icon(Icons.link),
              suffixIcon: IconButton(
                icon: const Icon(Icons.palette_outlined),
                tooltip: 'Select preset photo',
                onPressed: _showPhotoPickerSheet,
              ),
            ),
          ),
          const SizedBox(height: 32),

          CustomButton(
            text: 'Save Profile Changes',
            isLoading: _isSaving,
            icon: Icons.check_circle_outline,
            onPressed: _saveProfile,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildBuyerPreview() {
    final craftLabel = CraftCategories.all
        .firstWhere((c) => c.key == _craftType, orElse: () => CraftCategories.all.first)
        .label;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          CircleAvatar(
            radius: 54,
            backgroundColor: AppColors.secondaryLight.withValues(alpha: 0.3),
            backgroundImage: _photoUrlController.text.trim().isNotEmpty
                ? NetworkImage(_photoUrlController.text.trim())
                : null,
            child: _photoUrlController.text.trim().isEmpty
                ? const Icon(Icons.person, size: 60, color: AppColors.primary)
                : null,
          ),
          const SizedBox(height: 14),
          Text(
            _nameController.text.trim().isNotEmpty
                ? _nameController.text.trim()
                : 'Artisan Name',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            '${_locationController.text.trim().isNotEmpty ? _locationController.text.trim() : "Sri Lanka"} • $craftLabel Artisan',
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13.5),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: _verified
                  ? AppColors.accent.withValues(alpha: 0.12)
                  : AppColors.secondary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _verified ? AppColors.accent : AppColors.secondary,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _verified ? Icons.verified : Icons.shield_outlined,
                  color: _verified ? AppColors.accent : AppColors.secondary,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  _verified ? 'Verified Master Artisan' : 'Community Artisan',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _verified ? AppColors.accent : AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Story Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.auto_stories, color: AppColors.primary, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Artisan Journey & Heritage',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _aboutController.text.trim().isNotEmpty
                      ? _aboutController.text.trim()
                      : 'Dedicated to preserving Sri Lanka’s traditional artisanal heritage. Every piece is handcrafted using organic materials and traditional tools passed down through generations.',
                  style: const TextStyle(height: 1.6, color: AppColors.textSecondary, fontSize: 13.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Trust & Craft Highlights
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _buildHighlightRow(Icons.eco_outlined, 'Organic & Authentic',
                    'Crafted using indigenous natural raw materials.'),
                const Divider(height: 20),
                _buildHighlightRow(Icons.handyman_outlined, '100% Handcrafted',
                    'Traditional manual tools and heritage skill.'),
                const Divider(height: 20),
                _buildHighlightRow(Icons.place_outlined, 'Origin Guarantee',
                    _locationController.text.trim().isNotEmpty
                        ? _locationController.text.trim()
                        : 'Sri Lanka'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
      ],
    );
  }

  Widget _buildHighlightRow(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.primaryLight.withValues(alpha: 0.15),
          child: Icon(icon, size: 18, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }
}
