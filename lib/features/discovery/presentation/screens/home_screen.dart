import '../discovery_labels.dart';
import '../../../../core/localization/tr.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';

import '../../../../core/widgets/loading_indicator.dart';
import '../state/discovery_provider.dart';
import '../../../../core/constants/craft_categories.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../widgets/craft_category_chip.dart';
import '../widgets/master_artisan_spotlight_card.dart';
import '../widgets/product_card.dart';
import '../widgets/discovery_cart_action.dart';
import '../widgets/provenance_guarantee_card.dart';
import 'product_details_screen.dart';
import 'public_artisan_profile_screen.dart';
import 'search_screen.dart';
import 'favorites_screen.dart';

/// Assigned to: JAYAWARDANA V. K. A.
/// Branch: feature/buyer-discovery
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<DiscoveryProvider>().listenToFeaturedProducts();
    });
  }

  void _openFilterBottomSheet() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const SearchScreen(openFilters: true),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background.withOpacity(0.95),
        elevation: 0,
        scrolledUnderElevation: 1,
        titleSpacing: 16,
        title: const Text('Hasthakala',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search,
                color: AppColors.textPrimary, size: 22),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.favorite_border,
                    color: AppColors.textPrimary, size: 22),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const FavoritesScreen())),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const DiscoveryCartAction(),
          const SizedBox(width: 4),
          IconButton(
            tooltip: context.tr('discovery_my_profile'),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
            icon: const CircleAvatar(
                radius: 15,
                backgroundColor: AppColors.primary,
                child: Icon(Icons.person, size: 18, color: Colors.white)),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Consumer<DiscoveryProvider>(
        builder: (context, provider, _) {
          final displayProducts = provider.featuredProducts;

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              await provider.listenToFeaturedProducts();
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              children: [
                // Search Input with Filter Trigger
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SearchScreen()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 11),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                                color: Colors.black.withOpacity(0.05)),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    const Color(0xFF1C1917).withOpacity(0.05),
                                blurRadius: 12,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.search,
                                  size: 20, color: AppColors.primary),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  context.tr('discovery_home_search'),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _openFilterBottomSheet,
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEE7E3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.tune,
                          size: 20,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Horizontal Category Scroll Chips
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: CraftCategories.all.length + 1,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final category =
                          index == 0 ? null : CraftCategories.all[index - 1];
                      return CraftCategoryChip(
                        label: category == null
                            ? context.tr('discovery_all_crafts')
                            : discoveryCategoryLabel(context, category.key),
                        isSelected: index == 0,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SearchScreen(
                                    initialCategory: category?.key),
                              ));
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Master Artisan Spotlight Card
                if (displayProducts.isNotEmpty)
                  MasterArtisanSpotlightCard(
                    product: displayProducts.first,
                    onViewWorkshop: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PublicArtisanProfileScreen(
                            artisanId: displayProducts.first.artisanId,
                          ),
                        ),
                      );
                    },
                    onFeaturedProductTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailsScreen(
                            product: displayProducts.first,
                          ),
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 24),

                // Section Header: Curated Masterpieces
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.handyman_outlined,
                                size: 14, color: AppColors.secondary),
                            SizedBox(width: 4),
                            Text(
                              context.tr('discovery_rare'),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.secondary,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          context.tr('discovery_curated'),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SearchScreen()),
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            context.tr('discovery_explore'),
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondary,
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            size: 18,
                            color: AppColors.secondary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Product Grid / Loading State
                if (provider.isLoading)
                  Padding(
                    padding: EdgeInsets.all(40.0),
                    child: LoadingIndicator(
                        message: context.tr('discovery_loading')),
                  )
                else if (provider.errorMessage != null)
                  EmptyStateView(
                      icon: Icons.cloud_off,
                      title: context.tr('discovery_load_error'),
                      description: context.tr('discovery_retry_help'),
                      actionButtonText: context.tr('discovery_retry'),
                      onActionPressed: provider.listenToFeaturedProducts)
                else if (displayProducts.isEmpty)
                  EmptyStateView(
                      icon: Icons.brush_outlined,
                      title: context.tr('discovery_empty'),
                      description: context.tr('discovery_empty_help'))
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.70,
                    ),
                    itemCount: displayProducts.length,
                    itemBuilder: (context, index) {
                      final product = displayProducts[index];
                      return ProductCard(
                        product: product,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailsScreen(product: product),
                            ),
                          );
                        },
                      );
                    },
                  ),
                const SizedBox(height: 24),

                // Provenance Guarantee Trust Panel
                const ProvenanceGuaranteeCard(),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}
