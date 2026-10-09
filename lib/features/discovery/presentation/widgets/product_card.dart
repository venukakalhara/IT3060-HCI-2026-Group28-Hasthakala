import '../discovery_labels.dart';
import '../../../../core/localization/tr.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/shared_models/product_model.dart';
import '../../../../core/utils/currency_formatter.dart';
import 'discovery_cart_action.dart';
import 'favorite_button.dart';

class ProductCard extends StatefulWidget {
  final ProductModel product;
  final VoidCallback onTap;
  final VoidCallback? onAddToCart;

  const ProductCard({
    Key? key,
    required this.product,
    required this.onTap,
    this.onAddToCart,
  }) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isAdded = false;

  void _handleQuickAdd() {
    if (widget.onAddToCart != null) {
      widget.onAddToCart!();
      return;
    }
    if (!addDiscoveryProduct(context, widget.product)) return;
    setState(() => _isAdded = true);
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _isAdded = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final locationText = widget.product.district.isNotEmpty
        ? discoveryOriginLabel(context, widget.product.district)
        : context.tr('discovery_country');

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withOpacity(0.06), width: 1.0),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1C1917).withOpacity(0.04),
              blurRadius: 14,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Stack
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(15)),
                      child: Container(
                        color: AppColors.background,
                        child: widget.product.imageUrls.isNotEmpty
                            ? Image.network(
                                widget.product.imageUrls.first,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Center(
                                  child: Icon(Icons.image_not_supported,
                                      color: AppColors.textMuted),
                                ),
                              )
                            : const Center(
                                child: Icon(Icons.brush,
                                    color: AppColors.secondary, size: 40),
                              ),
                      ),
                    ),
                  ),

                  // Location Tag Overlay (Bottom Left)
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1917).withOpacity(0.75),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        locationText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 4,
                    right: 4,
                    child: Material(
                        color: AppColors.surface,
                        shape: const CircleBorder(),
                        child: FavoriteButton(productId: widget.product.id)),
                  ),
                ],
              ),
            ),

            // Details Section
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.artisanName.isNotEmpty
                        ? widget.product.artisanName
                        : context.tr('discovery_artisan'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr('discovery_price'),
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            CurrencyFormatter.formatLKR(
                                widget.product.priceLkr),
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 13.5,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: _handleQuickAdd,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: _isAdded
                                ? AppColors.primary
                                : AppColors.primary.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isAdded ? Icons.check : Icons.add,
                            size: 18,
                            color: _isAdded
                                ? AppColors.onPrimary
                                : AppColors.primary,
                          ),
                        ),
                      ),
                    ],
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
