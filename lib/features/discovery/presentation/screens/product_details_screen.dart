import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/shared_models/product_model.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_button.dart';
import 'public_artisan_profile_screen.dart';

/// Assigned to: JAYAWARDANA V. K. A.
/// Branch: feature/buyer-discovery
class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: product.title,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Gallery
            Container(
              height: 280,
              width: double.infinity,
              color: AppColors.background,
              child: product.imageUrls.isNotEmpty
                  ? Image.network(
                      product.imageUrls.first,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(Icons.brush, size: 60, color: AppColors.textMuted),
                      ),
                    )
                  : const Center(
                      child: Icon(Icons.brush, size: 60, color: AppColors.secondary),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryLight.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          product.category,
                          style: const TextStyle(
                            color: AppColors.secondaryDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text(
                            product.district,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    CurrencyFormatter.formatLKR(product.priceLkr),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  // Artisan Info Tile
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.secondaryLight,
                      child: Icon(Icons.person, color: AppColors.primaryDark),
                    ),
                    title: Text(
                      product.artisanName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text('Verified Sri Lankan Artisan'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PublicArtisanProfileScreen(artisanId: product.artisanId),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  const SizedBox(height: 12),
                  const Text(
                    'Craft Story & Details',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, -2))],
        ),
        child: Row(
          children: [
            Expanded(
              child: CustomButton(
                text: 'Add to Cart',
                isOutlined: true,
                onPressed: () {
                  // Connects with feature/buyer-purchase cart
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to Cart!')),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomButton(
                text: 'Buy Now',
                onPressed: () {
                  // Navigate to checkout
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
