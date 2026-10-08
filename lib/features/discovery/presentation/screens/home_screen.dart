import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../state/discovery_provider.dart';
import '../widgets/artisan_story_banner.dart';
import '../widgets/craft_category_chip.dart';
import '../widgets/product_card.dart';
import 'product_details_screen.dart';
import 'search_screen.dart';

/// Assigned to: JAYAWARDANA V. K. A.
/// Branch: feature/buyer-discovery
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 0;
  final List<String> _categories = [
    'All Crafts',
    'Pottery',
    'Batik',
    'Wood Carving',
    'Brassware',
    'Traditional Masks',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DiscoveryProvider>().listenToFeaturedProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Hasthakala',
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textPrimary),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<DiscoveryProvider>(
        builder: (context, provider, _) {
          return RefreshIndicator(
            onRefresh: () async {
              provider.listenToFeaturedProducts();
            },
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                ArtisanStoryBanner(
                  onExplore: () {
                    // Navigate to heritage / stories section
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Explore Handicrafts',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      return CraftCategoryChip(
                        label: _categories[index],
                        isSelected: _selectedCategoryIndex == index,
                        onTap: () {
                          setState(() {
                            _selectedCategoryIndex = index;
                          });
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Featured Creations',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                if (provider.isLoading)
                  const Padding(
                    padding: EdgeInsets.all(40.0),
                    child: LoadingIndicator(message: 'Loading authentic crafts...'),
                  )
                else if (provider.featuredProducts.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(32),
                    alignment: Alignment.center,
                    child: const Text('No products listed yet. Check back soon!'),
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: provider.featuredProducts.length,
                    itemBuilder: (context, index) {
                      final product = provider.featuredProducts[index];
                      return ProductCard(
                        product: product,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailsScreen(product: product),
                            ),
                          );
                        },
                      );
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
