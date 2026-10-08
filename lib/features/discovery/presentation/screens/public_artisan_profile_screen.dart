import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/shared_models/user_model.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../data/datasources/discovery_remote_datasource.dart';

/// Assigned to: JAYAWARDANA V. K. A.
/// Branch: feature/buyer-discovery
class PublicArtisanProfileScreen extends StatefulWidget {
  final String artisanId;

  const PublicArtisanProfileScreen({Key? key, required this.artisanId}) : super(key: key);

  @override
  State<PublicArtisanProfileScreen> createState() => _PublicArtisanProfileScreenState();
}

class _PublicArtisanProfileScreenState extends State<PublicArtisanProfileScreen> {
  final DiscoveryRemoteDataSource _dataSource = DiscoveryRemoteDataSource();
  UserModel? _artisan;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await _dataSource.getArtisanProfile(widget.artisanId);
    setState(() {
      _artisan = profile;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        appBar: CustomAppBar(title: 'Artisan Profile'),
        body: LoadingIndicator(message: 'Loading artisan bio...'),
      );
    }

    return Scaffold(
      appBar: const CustomAppBar(title: 'Master Artisan'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.secondaryLight,
              child: const Icon(Icons.person, size: 60, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(
              _artisan?.displayName ?? 'Artisan Craftsman',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              '${_artisan?.district ?? "Sri Lanka"} • Master Craftsman',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Artisan Journey & Heritage',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _artisan?.bio ??
                        'Dedicated to preserving Sri Lanka’s traditional artisanal heritage. Every piece is handcrafted using organic materials and traditional tools passed down through generations.',
                    style: const TextStyle(height: 1.5, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
