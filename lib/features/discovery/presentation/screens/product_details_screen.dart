import '../discovery_labels.dart';
import '../../../../core/localization/tr.dart';
import 'package:flutter/material.dart';
import '../widgets/product_purchase_bar.dart';
import '../widgets/favorite_button.dart';
import '../widgets/product_gallery.dart';
import '../widgets/product_share.dart';
import '../widgets/discovery_cart_action.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/shared_models/product_model.dart';
import '../../../../core/utils/currency_formatter.dart';
import 'public_artisan_profile_screen.dart';

/// Assigned to: JAYAWARDANA V. K. A.
/// Branch: feature/buyer-discovery
class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Collapsible Image Header
          SliverAppBar(
            expandedHeight: 340,
            pinned: true,
            backgroundColor: AppColors.background,
            elevation: 0,
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
            actions: [
              const DiscoveryCartAction(),
              FavoriteButton(productId: product.id),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.9),
                child: IconButton(
                  icon: const Icon(Icons.share_outlined,
                      color: AppColors.textPrimary, size: 20),
                  tooltip: context.tr('discovery_share_tooltip'),
                  onPressed: () => showProductShare(context, product),
                ),
              ),
              const SizedBox(width: 12),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: ProductGallery(
                      key: ValueKey(product.id), images: product.imageUrls)),
            ),
          ),

          // Product Details Content
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Chip(
                      label: Text(
                          discoveryCategoryLabel(context, product.category))),
                  const SizedBox(height: 12),

                  // Title & Rating
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Icon(Icons.star,
                          size: 16, color: AppColors.secondary),
                      const SizedBox(width: 4),
                      Text(
                        product.reviewCount > 0
                            ? product.rating.toStringAsFixed(1)
                            : context.tr('discovery_no_reviews'),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        product.reviewCount > 0
                            ? context.tr('discovery_reviews',
                                {'count': '${product.reviewCount}'})
                            : '',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Price & Stock Card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black.withOpacity(0.06)),
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.tr('discovery_fair_price'),
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textMuted,
                                letterSpacing: 0.6,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              CurrencyFormatter.formatLKR(product.priceLkr),
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF264E36).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.inventory,
                                  size: 14, color: AppColors.accent),
                              SizedBox(width: 4),
                              Text(
                                product.isAvailable && product.stockQuantity > 0
                                    ? context.tr('discovery_in_stock')
                                    : context.tr('discovery_out_stock'),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.accent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Master Artisan Profile Card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAF2EE),
                      borderRadius: BorderRadius.circular(16),
                      border:
                          Border.all(color: AppColors.border.withOpacity(0.6)),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: AppColors.primary.withOpacity(0.2),
                          child: const Icon(Icons.person_outline),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.artisanName.isNotEmpty
                                    ? product.artisanName
                                    : context.tr('discovery_meet_maker'),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                product.district.isNotEmpty
                                    ? discoveryOriginLabel(
                                        context, product.district)
                                    : context
                                        .tr('discovery_unavailable_details'),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                            child: TextButton(
                          onPressed: product.artisanId.isEmpty
                              ? null
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          PublicArtisanProfileScreen(
                                        artisanId: product.artisanId,
                                      ),
                                    ),
                                  );
                                },
                          child: Text(
                            context.tr('discovery_studio'),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Craft Story & Description
                  Text(
                    context.tr('discovery_story'),
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description.isNotEmpty
                        ? product.description
                        : context.tr('discovery_no_description'),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Materials & Specs Table
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black.withOpacity(0.05)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr('discovery_specs'),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textMuted,
                            letterSpacing: 0.6,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildSpecRow(
                          context.tr('discovery_materials'),
                          product.materials.isNotEmpty
                              ? product.materials
                              : context.tr('discovery_unavailable_details'),
                        ),
                        const Divider(height: 16),
                        _buildSpecRow(context.tr('discovery_technique'),
                            context.tr('discovery_unavailable_details')),
                        const Divider(height: 16),
                        _buildSpecRow(context.tr('discovery_packaging'),
                            context.tr('discovery_unavailable_details')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 90),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ProductPurchaseBar(product: product),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
