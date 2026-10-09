import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../account/presentation/screens/my_artisan_profile_screen.dart';
import '../../../account/presentation/state/auth_provider.dart';
import '../state/artisan_dashboard_provider.dart';
import '../state/artisan_orders_provider.dart';
import '../widgets/artisan_metric_card.dart';
import '../widgets/craft_image_view.dart';
import '../widgets/order_status_badge.dart';
import 'add_edit_product_screen.dart';
import 'artisan_order_details_screen.dart';
import 'artisan_orders_screen.dart';
import 'artisan_product_details_screen.dart';
import 'artisan_messages_screen.dart';
import 'manage_products_screen.dart';

/// Assigned to: KUMARI R. P. G. D.
/// Branch: feature/artisan-management
class ArtisanDashboardScreen extends StatefulWidget {
  final String artisanId;

  const ArtisanDashboardScreen({super.key, this.artisanId = ''});

  @override
  State<ArtisanDashboardScreen> createState() => _ArtisanDashboardScreenState();
}

class _ArtisanDashboardScreenState extends State<ArtisanDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDashboardData();
    });
  }

  void _loadDashboardData() {
    final auth = context.read<AuthProvider>();
    final effectiveArtisanId = widget.artisanId.isNotEmpty && widget.artisanId != 'sample_artisan_id'
        ? widget.artisanId
        : (auth.actingArtisanId ?? auth.currentUser?.uid ?? '');

    if (effectiveArtisanId.isNotEmpty) {
      context.read<ArtisanDashboardProvider>().listenToArtisanProducts(effectiveArtisanId);
      context.read<ArtisanOrdersProvider>().listenToArtisanOrders(effectiveArtisanId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final effectiveArtisanId = widget.artisanId.isNotEmpty && widget.artisanId != 'sample_artisan_id'
        ? widget.artisanId
        : (auth.actingArtisanId ?? auth.currentUser?.uid ?? '');
    final artisanName = auth.activeGrant?.artisanName ?? auth.currentUser?.displayName ?? 'Artisan';

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Workshop Hub',
        showBackButton: false,
      ),
      body: Consumer2<ArtisanDashboardProvider, ArtisanOrdersProvider>(
        builder: (context, dashboardProv, ordersProv, _) {
          final pendingOrdersCount = ordersProv.pendingCount + ordersProv.confirmedCount;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Shop Overview',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    // the shared I05 screen (Profile tab) - one profile screen in the app
                    onTap: auth.isSupporterContext
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const MyArtisanProfileScreen()),
                            );
                          },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.person_pin_outlined, size: 16, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text(
                            artisanName,
                            style: const TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ArtisanMetricCard(
                      title: 'Active Products',
                      value: '${dashboardProv.activeListings}',
                      icon: Icons.inventory_2_outlined,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ArtisanMetricCard(
                      title: 'Active Orders',
                      value: '$pendingOrdersCount',
                      icon: Icons.local_shipping_outlined,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ArtisanMetricCard(
                      title: 'Total Listings',
                      value: '${dashboardProv.totalListings}',
                      icon: Icons.storefront_outlined,
                      color: AppColors.primaryLight,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ArtisanMetricCard(
                      title: 'Completed Orders',
                      value: '${ordersProv.deliveredCount}',
                      icon: Icons.check_circle_outline,
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Quick Workshop Actions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 12),
              if (auth.canManageProducts) ...[
                ListTile(
                  tileColor: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.primaryLight,
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                  title: const Text('Add New Craft Creation',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('Publish pottery, batik, woodcraft listings'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddEditProductScreen(artisanId: effectiveArtisanId),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                ListTile(
                  tileColor: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.secondary,
                    child: Icon(Icons.list_alt, color: Colors.white),
                  ),
                  title: const Text('Manage Product Catalog',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Edit prices, update stock (${dashboardProv.totalListings} items)'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ManageProductsScreen(artisanId: effectiveArtisanId),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
              ],
              if (auth.canManageOrders) ...[
                ListTile(
                  tileColor: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.accent,
                    child: Icon(Icons.shopping_bag_outlined, color: Colors.white),
                  ),
                  title: const Text('Customer Craft Orders',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Fulfill and update status (${ordersProv.totalCount} orders)'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ArtisanOrdersScreen()),
                    );
                  },
                ),
                const SizedBox(height: 10),
              ],
              if (auth.canRespondToCustomers) ...[
                ListTile(
                  tileColor: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.success,
                    child: Icon(Icons.chat_bubble_outline, color: Colors.white),
                  ),
                  title: const Text('Customer Messages',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('Read and reply to buyers about their orders'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ArtisanMessagesScreen()),
                    );
                  },
                ),
                const SizedBox(height: 10),
              ],
              if (!auth.isSupporterContext)
                ListTile(
                  tileColor: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: Icon(Icons.badge_outlined, color: Colors.white),
                  ),
                  title: const Text('Manage Artisan Profile',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('Edit craft specialty, workshop bio and location'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MyArtisanProfileScreen()),
                    );
                  },
                ),
              const SizedBox(height: 24),

              // Recent Orders Section
              if (ordersProv.incomingOrders.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Orders',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ArtisanOrdersScreen()),
                        );
                      },
                      child: const Text('See All'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                for (final order in ordersProv.incomingOrders.take(2))
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Order #${order.id.length > 8 ? order.id.substring(0, 8) : order.id}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                          OrderStatusBadge(status: order.status, isCompact: true),
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          '${order.recipientName.isNotEmpty ? order.recipientName : order.buyerName} • ${CurrencyFormatter.formatLKR(order.totalAmountLkr)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 13),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ArtisanOrderDetailsScreen(order: order)),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 16),
              ],

              // Recent Products Section
              if (dashboardProv.myProducts.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Featured Listings',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ManageProductsScreen(artisanId: effectiveArtisanId)),
                        );
                      },
                      child: const Text('View All'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                for (final product in dashboardProv.myProducts.take(2))
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      leading: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: product.imageUrls.isNotEmpty
                            ? CraftImageView(
                                imagePath: product.imageUrls.first,
                                width: 44,
                                height: 44,
                                fit: BoxFit.cover,
                                borderRadius: BorderRadius.circular(8),
                                fallback: const Icon(Icons.brush, color: AppColors.secondary, size: 20),
                              )
                            : const Icon(Icons.brush, color: AppColors.secondary, size: 20),
                      ),
                      title: Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                      subtitle: Text('${CurrencyFormatter.formatLKR(product.priceLkr)} • Stock: ${product.stockQuantity}',
                          style: const TextStyle(fontSize: 12)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 13),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ArtisanProductDetailsScreen(product: product)),
                        );
                      },
                    ),
                  ),
              ],
            ],
          );
        },
      ),
    );
  }
}
