import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/craft_categories.dart';
import '../../../../core/shared_models/product_model.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../account/presentation/state/auth_provider.dart';
import '../state/product_crud_provider.dart';
import '../widgets/craft_image_view.dart';
import '../widgets/product_delete_dialog.dart';
import 'add_edit_product_screen.dart';
import 'artisan_chat_screen.dart';

class ArtisanProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ArtisanProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  State<ArtisanProductDetailsScreen> createState() => _ArtisanProductDetailsScreenState();
}

class _ArtisanProductDetailsScreenState extends State<ArtisanProductDetailsScreen> {
  late ProductModel _product;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _product = widget.product;
  }

  void _showDeleteConfirmation(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    ProductDeleteDialog.show(
      context,
      productTitle: _product.title,
      onConfirm: () async {
        final crudProvider = context.read<ProductCrudProvider>();
        final success = await crudProvider.deleteProduct(_product.id);
        if (!mounted) return;
        if (success) {
          messenger.showSnackBar(
            SnackBar(content: Text('"${_product.title}" has been deleted.')),
          );
          navigator.pop();
        } else {
          messenger.showSnackBar(
            SnackBar(content: Text(crudProvider.errorMessage ?? 'Could not delete product.')),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final canManage = auth.canManageProducts;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Craft Listing Details',
        actions: [
          if (canManage)
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
              tooltip: 'Edit Listing',
              onPressed: () async {
                final updated = await Navigator.push<ProductModel?>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddEditProductScreen(
                      artisanId: _product.artisanId,
                      productToEdit: _product,
                    ),
                  ),
                );
                if (updated != null && mounted) {
                  setState(() => _product = updated);
                }
              },
            ),
          if (canManage)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.error),
              tooltip: 'Delete Listing',
              onPressed: () => _showDeleteConfirmation(context),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Gallery Header
            Container(
              height: 280,
              width: double.infinity,
              color: AppColors.background,
              child: _product.imageUrls.isNotEmpty
                  ? Stack(
                      children: [
                        PageView.builder(
                          itemCount: _product.imageUrls.length,
                          onPageChanged: (i) => setState(() => _currentImageIndex = i),
                          itemBuilder: (context, index) {
                            return CraftImageView(
                              imagePath: _product.imageUrls[index],
                              fit: BoxFit.cover,
                              fallback: const Center(
                                child: Icon(Icons.brush, size: 60, color: AppColors.textMuted),
                              ),
                            );
                          },
                        ),
                        if (_product.imageUrls.length > 1)
                          Positioned(
                            bottom: 12,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(_product.imageUrls.length, (i) {
                                return Container(
                                  width: 8,
                                  height: 8,
                                  margin: const EdgeInsets.symmetric(horizontal: 3),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _currentImageIndex == i
                                        ? AppColors.primary
                                        : Colors.white70,
                                  ),
                                );
                              }),
                            ),
                          ),
                      ],
                    )
                  : const Center(
                      child: Icon(Icons.brush, size: 64, color: AppColors.secondary),
                    ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stock & Availability Status Card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _product.isAvailable && _product.stockQuantity > 0
                                        ? AppColors.accent
                                        : AppColors.error,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _product.isAvailable
                                      ? (_product.stockQuantity > 0 ? 'Active in Shop' : 'Out of Stock')
                                      : 'Hidden from Shop',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Inventory Stock: ${_product.stockQuantity} units',
                              style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                        if (canManage)
                          Switch(
                            value: _product.isAvailable,
                            activeThumbColor: AppColors.primary,
                            onChanged: (val) async {
                              final crudProvider = context.read<ProductCrudProvider>();
                              final messenger = ScaffoldMessenger.of(context);
                              final success = await crudProvider.toggleAvailability(
                                _product.id,
                                val,
                                updatedBy: auth.currentUser?.uid,
                              );
                              if (success && mounted) {
                                setState(() {
                                  _product = ProductModel(
                                    id: _product.id,
                                    artisanId: _product.artisanId,
                                    artisanName: _product.artisanName,
                                    title: _product.title,
                                    description: _product.description,
                                    priceLkr: _product.priceLkr,
                                    category: _product.category,
                                    materials: _product.materials,
                                    imageUrls: _product.imageUrls,
                                    stockQuantity: _product.stockQuantity,
                                    district: _product.district,
                                    isAvailable: val,
                                    createdAt: _product.createdAt,
                                    updatedAt: DateTime.now(),
                                  );
                                });
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text(val ? 'Listing set to Active.' : 'Listing set to Hidden.'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Category and District chips
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          CraftCategories.labelFor(_product.category),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (_product.district.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.location_on_outlined, size: 14, color: AppColors.secondaryDark),
                              const SizedBox(width: 4),
                              Text(
                                _product.district,
                                style: const TextStyle(
                                  color: AppColors.secondaryDark,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  Text(
                    _product.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 8),
                  Text(
                    CurrencyFormatter.formatLKR(_product.priceLkr),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),

                  const Divider(height: 32),

                  // Materials Section
                  if (_product.materials.isNotEmpty) ...[
                    const Text(
                      'Materials & Craft Technique',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _product.materials,
                      style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Description Section
                  const Text(
                    'Heritage Story & Description',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _product.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Customer Product Inquiries Tile (I09 linked)
                  ListTile(
                    tileColor: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: const BorderSide(color: AppColors.border),
                    ),
                    leading: const CircleAvatar(
                      backgroundColor: Color(0x1F264E36),
                      child: Icon(Icons.question_answer_outlined, color: AppColors.accent),
                    ),
                    title: const Text('Customer Inquiries', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: const Text('Questions asked by buyers regarding this craft item', style: TextStyle(fontSize: 12)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                    onTap: () {
                      // Open product query chat
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ArtisanChatScreen(
                            chatId: '${_product.id}_inquiry',
                            artisanId: _product.artisanId,
                            buyerId: 'customer',
                            buyerName: 'Customer Inquiry',
                            productTitle: _product.title,
                            productPrice: _product.priceLkr,
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  if (canManage)
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'Edit Craft',
                            isOutlined: true,
                            onPressed: () async {
                              final updated = await Navigator.push<ProductModel?>(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddEditProductScreen(
                                    artisanId: _product.artisanId,
                                    productToEdit: _product,
                                  ),
                                ),
                              );
                              if (updated != null && mounted) {
                                setState(() => _product = updated);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.error,
                              foregroundColor: AppColors.onPrimary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () => _showDeleteConfirmation(context),
                            child: const Text('Delete Listing', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
