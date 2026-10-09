import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/shared_models/order_model.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_time_utils.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../account/presentation/state/auth_provider.dart';
import '../state/artisan_orders_provider.dart';
import '../widgets/order_action_bottom_sheet.dart';
import '../widgets/order_status_badge.dart';
import 'artisan_chat_screen.dart';
import 'artisan_messages_screen.dart';
import 'artisan_order_details_screen.dart';

/// Assigned to: KUMARI R. P. G. D.
/// Branch: feature/artisan-management
class ArtisanOrdersScreen extends StatefulWidget {
  const ArtisanOrdersScreen({super.key});

  @override
  State<ArtisanOrdersScreen> createState() => _ArtisanOrdersScreenState();
}

class _ArtisanOrdersScreenState extends State<ArtisanOrdersScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadOrders();
    });
  }

  void _loadOrders() {
    final auth = context.read<AuthProvider>();
    final artisanId = auth.actingArtisanId ?? auth.currentUser?.uid ?? '';
    if (artisanId.isNotEmpty) {
      context.read<ArtisanOrdersProvider>().listenToArtisanOrders(artisanId);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openOrderDetails(OrderModel order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ArtisanOrderDetailsScreen(order: order),
      ),
    );
  }

  void _openChat(OrderModel order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ArtisanChatScreen(
          chatId: order.id,
          artisanId: order.artisanId,
          buyerId: order.buyerId,
          buyerName: order.buyerName,
          orderId: order.id,
          orderTotal: order.totalAmountLkr,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final canManageOrders = auth.canManageOrders;
    final canChat = auth.canRespondToCustomers;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Customer Orders',
        actions: [
          if (canChat)
            IconButton(
              icon: const Icon(Icons.chat_bubble_outline, color: AppColors.primary),
              tooltip: 'Customer Messages',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ArtisanMessagesScreen()),
                );
              },
            ),
        ],
      ),
      body: Consumer<ArtisanOrdersProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const LoadingIndicator(message: 'Loading customer orders...');
          }

          final allOrders = provider.incomingOrders;
          final filtered = provider.filteredOrders;

          if (allOrders.isEmpty && provider.errorMessage != null) {
            return EmptyStateView(
              icon: Icons.cloud_off_outlined,
              title: 'Could not load orders',
              description: 'Check your connection and try again.',
              actionButtonText: 'Try again',
              onActionPressed: _loadOrders,
            );
          }

          if (allOrders.isEmpty) {
            return const EmptyStateView(
              icon: Icons.local_shipping_outlined,
              title: 'No customer orders yet',
              description: 'When buyers purchase your handcrafted items, their orders will appear here.',
            );
          }

          return Column(
            children: [
              // Search & Filter Header
              Container(
                color: AppColors.surface,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      onChanged: provider.setSearchQuery,
                      decoration: InputDecoration(
                        hintText: 'Search by Order ID, customer, item...',
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
                    // Status Horizontal Filter
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildStatusChip(
                            label: 'All (${provider.totalCount})',
                            isSelected: provider.selectedStatus == null,
                            onSelected: () => provider.setStatusFilter(null),
                          ),
                          const SizedBox(width: 8),
                          _buildStatusChip(
                            label: 'Pending (${provider.pendingCount})',
                            isSelected: provider.selectedStatus == OrderStatus.pending,
                            onSelected: () => provider.setStatusFilter(OrderStatus.pending),
                            color: AppColors.secondary,
                          ),
                          const SizedBox(width: 8),
                          _buildStatusChip(
                            label: 'Confirmed (${provider.confirmedCount})',
                            isSelected: provider.selectedStatus == OrderStatus.confirmed,
                            onSelected: () => provider.setStatusFilter(OrderStatus.confirmed),
                            color: AppColors.primaryLight,
                          ),
                          const SizedBox(width: 8),
                          _buildStatusChip(
                            label: 'Preparing (${provider.preparingCount})',
                            isSelected: provider.selectedStatus == OrderStatus.preparing,
                            onSelected: () => provider.setStatusFilter(OrderStatus.preparing),
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          _buildStatusChip(
                            label: 'Shipped (${provider.shippedCount})',
                            isSelected: provider.selectedStatus == OrderStatus.shipped,
                            onSelected: () => provider.setStatusFilter(OrderStatus.shipped),
                            color: AppColors.secondaryDark,
                          ),
                          const SizedBox(width: 8),
                          _buildStatusChip(
                            label: 'Delivered (${provider.deliveredCount})',
                            isSelected: provider.selectedStatus == OrderStatus.delivered,
                            onSelected: () => provider.setStatusFilter(OrderStatus.delivered),
                            color: AppColors.accent,
                          ),
                          const SizedBox(width: 8),
                          _buildStatusChip(
                            label: 'Cancelled (${provider.cancelledCount})',
                            isSelected: provider.selectedStatus == OrderStatus.cancelled,
                            onSelected: () => provider.setStatusFilter(OrderStatus.cancelled),
                            color: AppColors.error,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Orders List
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.receipt_long_outlined, size: 48, color: AppColors.textMuted),
                              const SizedBox(height: 12),
                              const Text(
                                'No matching orders',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Try clearing search terms or selecting another status filter.',
                                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                              ),
                              const SizedBox(height: 16),
                              OutlinedButton(
                                onPressed: () {
                                  _searchController.clear();
                                  provider.setSearchQuery('');
                                  provider.setStatusFilter(null);
                                },
                                child: const Text('Reset Filters'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final order = filtered[index];
                          final itemsCount = order.items.fold<int>(0, (sum, i) => sum + i.quantity);
                          final itemsPreview = order.items.map((i) => i.title).take(2).join(', ');
                          final hasMore = order.items.length > 2;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () => _openOrderDetails(order),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Header: Order ID & Status Badge
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                  color: AppColors.primary.withValues(alpha: 0.1),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: const Icon(Icons.receipt, color: AppColors.primary, size: 16),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                'Order #${order.id.length > 8 ? order.id.substring(0, 8) : order.id}',
                                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                              ),
                                            ],
                                          ),
                                          OrderStatusBadge(status: order.status),
                                        ],
                                      ),
                                      const Divider(height: 20),

                                      // Customer Info & Date
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Customer: ${order.recipientName.isNotEmpty ? order.recipientName : order.buyerName}',
                                            style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            DateTimeUtils.formatOrderDate(order.createdAt),
                                            style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),

                                      // Items summary
                                      Text(
                                        '$itemsCount items: $itemsPreview${hasMore ? '...' : ''}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
                                      ),
                                      const SizedBox(height: 8),

                                      // Total Amount
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Total: ${CurrencyFormatter.formatLKR(order.totalAmountLkr)}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                          Text(
                                            order.paymentMethod == PaymentMethods.cashOnDelivery ? 'COD' : 'Bank Transfer',
                                            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 12),

                                      // Action Buttons on Card
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          if (canChat)
                                            TextButton.icon(
                                              icon: const Icon(Icons.chat_bubble_outline, size: 15),
                                              label: const Text('Message', style: TextStyle(fontSize: 12.5)),
                                              onPressed: () => _openChat(order),
                                            ),
                                          const SizedBox(width: 4),
                                          if (canManageOrders)
                                            OutlinedButton.icon(
                                              style: OutlinedButton.styleFrom(
                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                minimumSize: const Size(0, 36),
                                              ),
                                              icon: const Icon(Icons.edit_note, size: 16),
                                              label: const Text('Status', style: TextStyle(fontSize: 12.5)),
                                              onPressed: () {
                                                final messenger = ScaffoldMessenger.of(context);
                                                showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  builder: (_) => OrderActionBottomSheet(
                                                    order: order,
                                                    onStatusChanged: (newStatus, reason) async {
                                                      final ok = await provider.changeOrderStatus(
                                                        orderId: order.id,
                                                        status: newStatus,
                                                        updatedByUid: auth.currentUser?.uid,
                                                        cancelReason: reason,
                                                      );
                                                      messenger.showSnackBar(
                                                        SnackBar(
                                                          content: Text(ok
                                                              ? 'Order status updated to ${newStatus.name.toUpperCase()}'
                                                              : 'Status not saved. Check your connection and try again.'),
                                                          backgroundColor: ok ? null : AppColors.error,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                );
                                              },
                                            ),
                                          const SizedBox(width: 8),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.primary,
                                              foregroundColor: AppColors.onPrimary,
                                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                              minimumSize: const Size(0, 36),
                                            ),
                                            child: const Text('Details', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
                                            onPressed: () => _openOrderDetails(order),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatusChip({
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
    Color? color,
  }) {
    final effectiveColor = color ?? AppColors.primary;
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
      selectedColor: effectiveColor,
      backgroundColor: AppColors.background,
      side: BorderSide(color: isSelected ? effectiveColor : AppColors.border),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      onSelected: (_) => onSelected(),
    );
  }
}
