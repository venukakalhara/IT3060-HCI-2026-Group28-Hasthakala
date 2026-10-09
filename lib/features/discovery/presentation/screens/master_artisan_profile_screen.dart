import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/shared_models/product_model.dart';
import '../widgets/product_card.dart';

/// High-Fidelity Master Artisan Profile Screen matching Stitch Canvas specification
class MasterArtisanProfileScreen extends StatefulWidget {
  const MasterArtisanProfileScreen({super.key});

  @override
  State<MasterArtisanProfileScreen> createState() =>
      _MasterArtisanProfileScreenState();
}

class _MasterArtisanProfileScreenState
    extends State<MasterArtisanProfileScreen> {
  final List<ProductModel> _artisanCrafts = [
    ProductModel(
      id: 'm_1',
      artisanId: 'artisan_sunil',
      artisanName: 'Sunil Kariyawasam',
      title: 'Heritage Terracotta Water Jug',
      description:
          'Organic unglazed terracotta jug, hand-spun on traditional kick wheel using Kelaniya clay.',
      priceLkr: 2400.0,
      category: 'Pottery & Clay',
      materials: 'Natural Terracotta',
      district: 'Kelaniya',
      rating: 4.9,
      reviewCount: 38,
      imageUrls: [
        'https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?auto=format&fit=crop&q=80&w=600',
      ],
    ),
    ProductModel(
      id: 'm_2',
      artisanId: 'artisan_sunil',
      artisanName: 'Sunil Kariyawasam',
      title: 'Ancient Sri Lankan Clay Water Pot',
      description:
          'Earthen pot for natural water cooling and traditional cooking.',
      priceLkr: 1950.0,
      category: 'Pottery & Clay',
      materials: 'Natural Terracotta',
      district: 'Kelaniya',
      rating: 4.8,
      reviewCount: 26,
      imageUrls: [
        'https://images.unsplash.com/photo-1610701596007-11502861dcfa?auto=format&fit=crop&q=80&w=600',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Workshop Cover Header
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.9),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: AppColors.textPrimary, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      'https://images.unsplash.com/photo-1565193566173-7a0ee3dbe261?auto=format&fit=crop&q=80&w=800',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: AppColors.surface),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.75),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.location_on,
                              color: Colors.white, size: 14),
                          SizedBox(width: 4),
                          Text(
                            'Kelaniya Riverbank Shed',
                            style: TextStyle(color: Colors.white, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Profile Info Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        onBackgroundImageError: (_, __) {},
                        radius: 36,
                        backgroundImage: NetworkImage(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuDTSOgarZ8KIanzm-nSN7REc-EHyLNFMeBEAzkjLQtqAphmhd6AXqNJtpoKNf1fwBroTpESgrnH1s0ZM6NBJuE1JWdlHzI29wlOY-qQZOdR-9T_EeJ64yHl51LOBmW8T_LOpeSHuPi1Sz0yAzUYbF1HB3-n_irDxiG93-2pOJqf-YbdIsfkWIPb_VHe7zjVUP3PETv1bAj0GT4odSVvTxkWsNknvtLoieDTwzATzDIGimOjUxTSK_qqJQ',
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              children: const [
                                Text(
                                  'Sunil Kariyawasam',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Icon(Icons.verified,
                                    color: AppColors.accent, size: 18),
                              ],
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Master Terracotta Craftsman • 35 Yrs Experience',
                              style: TextStyle(
                                  fontSize: 12, color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF264E36)
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'Guild ID: #SL-8841',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF264E36),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.star,
                                    color: Colors.amber, size: 14),
                                const SizedBox(width: 2),
                                const Text(
                                  '4.9 (48 Reviews)',
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  const Text('Sample artisan profile',
                      style: TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  // Maker Philosophy Quote
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Icon(Icons.format_quote,
                            color: AppColors.primary, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '“Each jug holds earth mixed with river water, spun the way my ancestors did for generations.”',
                            style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Action Buttons (Commission & Reviews)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          icon: const Icon(Icons.rate_review_outlined,
                              size: 18, color: AppColors.primary),
                          label: const Text(
                            'Read Reviews',
                            style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/artisan-reviews');
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          icon: const Icon(Icons.brush,
                              size: 18, color: Colors.white),
                          label: const Text(
                            'Commission Piece',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/custom-commission');
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Handcrafted Collection by Sunil',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          // Crafts Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final p = _artisanCrafts[index];
                  return ProductCard(
                    product: p,
                    onTap: () => Navigator.pushNamed(
                        context, '/product-details',
                        arguments: p),
                  );
                },
                childCount: _artisanCrafts.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}
