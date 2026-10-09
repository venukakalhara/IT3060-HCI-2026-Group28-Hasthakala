import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/shared_models/product_model.dart';
import '../widgets/product_card.dart';

/// High-Fidelity Craft Catalog Screen matching Stitch Canvas specification
class CraftCatalogScreen extends StatefulWidget {
  const CraftCatalogScreen({super.key});

  @override
  State<CraftCatalogScreen> createState() => _CraftCatalogScreenState();
}

class _CraftCatalogScreenState extends State<CraftCatalogScreen> {
  int _selectedFilterIndex = 0;
  String _sort = 'curated';

  final List<String> _filters = [
    'All Catalogs',
    'Terracotta & Clay',
    'Kaduru Masks',
    'Dumbara Weave',
    'Brass Casting',
  ];

  final List<ProductModel> _catalogProducts = [
    ProductModel(
      id: 'cat_1',
      artisanId: 'artisan_sunil',
      artisanName: 'Sunil K.',
      title: 'Terracotta Water Jug',
      description: 'Raw unglazed terracotta water jug, handmade in Kelaniya.',
      priceLkr: 2400.0,
      category: 'Terracotta & Clay',
      materials: 'Terracotta Clay',
      district: 'Kelaniya',
      rating: 4.9,
      reviewCount: 38,
      imageUrls: [
        'https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?auto=format&fit=crop&q=80&w=600',
      ],
    ),
    ProductModel(
      id: 'cat_2',
      artisanId: 'artisan_kamal',
      artisanName: 'Kamal P.',
      title: 'Gurulu Raksha Mask',
      description: 'Hand-carved Kaduru wood mask with natural mineral paints.',
      priceLkr: 3200.0,
      category: 'Kaduru Masks',
      materials: 'Kaduru Wood',
      district: 'Ambalangoda',
      rating: 4.8,
      reviewCount: 29,
      imageUrls: [
        'https://images.unsplash.com/photo-1584727638096-042c45049ebe?auto=format&fit=crop&q=80&w=600',
      ],
    ),
    ProductModel(
      id: 'cat_3',
      artisanId: 'artisan_nalini',
      artisanName: 'Nalini A.',
      title: 'Dumbara Table Runner',
      description: 'Traditional geometric Dumbara pit-loom weave mat.',
      priceLkr: 1800.0,
      category: 'Dumbara Weave',
      materials: 'Nidi Grass',
      district: 'Kandy',
      rating: 5.0,
      reviewCount: 42,
      imageUrls: [
        'https://images.unsplash.com/photo-1606744824163-985d376605aa?auto=format&fit=crop&q=80&w=600',
      ],
    ),
    ProductModel(
      id: 'cat_4',
      artisanId: 'artisan_nimali',
      artisanName: 'Nimali F.',
      title: 'Kitul Oil Coconut Shell Bowl',
      description:
          'Hand-polished coconut shell bowl treated with pure kitul oil.',
      priceLkr: 1200.0,
      category: 'Woodcarving',
      materials: 'Coconut Shell',
      district: 'Kurunegala',
      rating: 4.7,
      reviewCount: 22,
      imageUrls: [
        'https://images.unsplash.com/photo-1610701596007-11502861dcfa?auto=format&fit=crop&q=80&w=600',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredList = _selectedFilterIndex == 0
        ? _catalogProducts.toList()
        : _catalogProducts
            .where((p) => p.category == _filters[_selectedFilterIndex])
            .toList();

    if (_sort == 'low')
      filteredList.sort((a, b) => a.priceLkr.compareTo(b.priceLkr));
    if (_sort == 'high')
      filteredList.sort((a, b) => b.priceLkr.compareTo(a.priceLkr));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Sri Lankan Craft Catalog',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            tooltip: 'Sort catalog',
            icon: const Icon(Icons.sort, color: AppColors.primary),
            initialValue: _sort,
            onSelected: (value) => setState(() => _sort = value),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'curated', child: Text('Curated order')),
              PopupMenuItem(value: 'low', child: Text('Price: low to high')),
              PopupMenuItem(value: 'high', child: Text('Price: high to low')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
              padding: EdgeInsets.all(12),
              child: Text('Sample collection',
                  style: TextStyle(color: AppColors.textSecondary))),
          // Filter Chips
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedFilterIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFilterIndex = index),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8, top: 4, bottom: 4),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Text(
                      _filters[index],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color:
                            isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // Catalog Grid
          Expanded(
            child: filteredList.isEmpty
                ? const Center(child: Text('No crafts in this category yet.'))
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.68,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final product = filteredList[index];
                      return ProductCard(
                        product: product,
                        onTap: () => Navigator.pushNamed(
                            context, '/product-details',
                            arguments: product),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
