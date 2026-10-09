import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../account/presentation/state/auth_provider.dart';
import '../state/artisan_dashboard_provider.dart';
import '../state/product_crud_provider.dart';
import '../widgets/product_delete_dialog.dart';
import '../widgets/product_inventory_tile.dart';
import 'add_edit_product_screen.dart';
import 'artisan_product_details_screen.dart';

/// Assigned to: KUMARI R. P. G. D.
/// Branch: feature/artisan-management
class ManageProductsScreen extends StatefulWidget {
  final String artisanId;

  const ManageProductsScreen({
    super.key,
    required this.artisanId,
  });

  @override
  State<ManageProductsScreen> createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProducts();
    });
  }

  void _loadProducts() {
    final auth = context.read<AuthProvider>();
    final effectiveId = widget.artisanId.isNotEmpty && widget.artisanId != 'sample_artisan_id'
        ? widget.artisanId
        : (auth.actingArtisanId ?? auth.currentUser?.uid ?? '');
    if (effectiveId.isNotEmpty) {
      context.read<ArtisanDashboardProvider>().listenToArtisanProducts(effectiveId);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openAddProduct(String artisanId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditProductScreen(artisanId: artisanId),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String productId, String title) {
    final messenger = ScaffoldMessenger.of(context);
    ProductDeleteDialog.show(
      context,
      productTitle: title,
      onConfirm: () async {
        final crudProvider = context.read<ProductCrudProvider>();
        final success = await crudProvider.deleteProduct(productId);
        if (!mounted) return;
        if (success) {
          messenger.showSnackBar(
            SnackBar(content: Text('"$title" deleted.')),
          );
        } else {
          messenger.showSnackBar(
            SnackBar(content: Text(crudProvider.errorMessage ?? 'Failed to delete.')),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final effectiveArtisanId = widget.artisanId.isNotEmpty && widget.artisanId != 'sample_artisan_id'
        ? widget.artisanId
        : (auth.actingArtisanId ?? auth.currentUser?.uid ?? '');
    final canManage = auth.canManageProducts;

    return ChangeNotifierProvider(
      create: (_) => ProductCrudProvider(),
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Craft Catalogue',
          actions: [
            if (canManage)
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: AppColors.primary, size: 26),
                tooltip: 'Add New Craft Listing',
                onPressed: () => _openAddProduct(effectiveArtisanId),
              ),
          ],
        ),
        floatingActionButton: canManage
            ? FloatingActionButton.extended(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                icon: const Icon(Icons.add),
                label: const Text('New Craft', style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () => _openAddProduct(effectiveArtisanId),
              )
            : null,
        body: Consumer<ArtisanDashboardProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const LoadingIndicator(message: 'Loading craft inventory...');
            }

            final allProducts = provider.myProducts;
            final filtered = provider.filteredProducts;

            if (allProducts.isEmpty && provider.errorMessage != null) {
              return EmptyStateView(
                icon: Icons.cloud_off_outlined,
                title: 'Could not load your crafts',
                description: 'Check your connection and try again.',
                actionButtonText: 'Try again',
                onActionPressed: _loadProducts,
              );
            }

            if (allProducts.isEmpty) {
              return EmptyStateView(
                icon: Icons.inventory_2_outlined,
                title: 'No crafts in catalogue',
                description: 'Start showcasing your handicraft creations to customers worldwide.',
                actionButtonText: canManage ? 'Add First Craft' : null,
                onActionPressed: canManage ? () => _openAddProduct(effectiveArtisanId) : null,
              );
            }

            return Column(
              children: [
                // Search Bar & Filter Strip
                Container(
                  color: AppColors.surface,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Column(
                    children: [
                      TextField(
                        controller: _searchController,
                        onChanged: provider.setSearchQuery,
                        decoration: InputDecoration(
                          hintText: 'Search craft titles or categories...',
                          prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 18),
                                  onPressed: () {
                                    _searchController.clear();
                                    provider.setSearchQuery('');
                                  },
                                )
                              : null,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Stock Filter Chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterChip(
                              label: 'All (${provider.totalListings})',
                              isSelected: provider.stockFilter == 'all',
                              onSelected: () => provider.setStockFilter('all'),
                            ),
                            const SizedBox(width: 8),
                            _buildFilterChip(
                              label: 'In Stock (${provider.inStockCount})',
                              isSelected: provider.stockFilter == 'in_stock',
                              onSelected: () => provider.setStockFilter('in_stock'),
                            ),
                            const SizedBox(width: 8),
                            _buildFilterChip(
                              label: 'Low Stock (${provider.lowStockCount})',
                              isSelected: provider.stockFilter == 'low_stock',
                              onSelected: () => provider.setStockFilter('low_stock'),
                              isWarning: true,
                            ),
                            const SizedBox(width: 8),
                            _buildFilterChip(
                              label: 'Out of Stock (${provider.outOfStockCount})',
                              isSelected: provider.stockFilter == 'out_of_stock',
                              onSelected: () => provider.setStockFilter('out_of_stock'),
                              isError: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // Products List
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.search_off, size: 48, color: AppColors.textMuted),
                                const SizedBox(height: 12),
                                const Text(
                                  'No matching creations found',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Try adjusting your search query or stock filter.',
                                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                                ),
                                const SizedBox(height: 16),
                                OutlinedButton(
                                  onPressed: () {
                                    _searchController.clear();
                                    provider.setSearchQuery('');
                                    provider.setStockFilter('all');
                                  },
                                  child: const Text('Reset Filters'),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final product = filtered[index];
                            return ProductInventoryTile(
                              product: product,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ArtisanProductDetailsScreen(product: product),
                                  ),
                                );
                              },
                              onEdit: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AddEditProductScreen(
                                      artisanId: effectiveArtisanId,
                                      productToEdit: product,
                                    ),
                                  ),
                                );
                              },
                              onDelete: () {
                                _showDeleteDialog(context, product.id, product.title);
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
    bool isWarning = false,
    bool isError = false,
  }) {
    Color activeColor = AppColors.primary;
    if (isWarning) activeColor = AppColors.secondary;
    if (isError) activeColor = AppColors.error;

    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected ? AppColors.onPrimary : AppColors.textSecondary,
        ),
      ),
      selected: isSelected,
      selectedColor: activeColor,
      backgroundColor: AppColors.background,
      side: BorderSide(color: isSelected ? activeColor : AppColors.border),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      onSelected: (_) => onSelected(),
    );
  }
}
