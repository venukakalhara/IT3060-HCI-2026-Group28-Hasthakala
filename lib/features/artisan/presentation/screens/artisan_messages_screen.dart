import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/shared_models/conversation_model.dart';
import '../../../../core/shared_models/order_model.dart';
import '../../../../core/utils/date_time_utils.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../account/presentation/state/auth_provider.dart';
import '../../data/datasources/artisan_chat_datasource.dart';
import '../state/artisan_orders_provider.dart';
import 'artisan_chat_screen.dart';

/// I09 (artisan side) - customer messages.
/// Lists the chats buyers started on this shop's orders, newest first,
/// so the artisan (or a supporter allowed to reply) can see and answer them.
class ArtisanMessagesScreen extends StatefulWidget {
  const ArtisanMessagesScreen({super.key});

  @override
  State<ArtisanMessagesScreen> createState() => _ArtisanMessagesScreenState();
}

class _ArtisanMessagesScreenState extends State<ArtisanMessagesScreen> {
  final ArtisanChatDataSource _dataSource = ArtisanChatDataSource();
  Stream<List<ConversationModel>>? _stream;
  String _artisanId = '';

  @override
  void initState() {
    super.initState();
    _artisanId = context.read<AuthProvider>().actingArtisanId ?? '';
    if (_artisanId.isNotEmpty) {
      _stream = _dataSource.streamArtisanConversations(_artisanId);
    }
  }

  void _retry() {
    if (_artisanId.isEmpty) return;
    setState(() {
      _stream = _dataSource.streamArtisanConversations(_artisanId);
    });
  }

  OrderModel? _findOrder(String? orderId) {
    if (orderId == null) return null;
    final orders = context.read<ArtisanOrdersProvider>().incomingOrders;
    for (final order in orders) {
      if (order.id == orderId) return order;
    }
    return null;
  }

  void _openChat(ConversationModel chat) {
    final order = _findOrder(chat.orderId);
    final buyerName = order == null
        ? 'Customer'
        : (order.recipientName.isNotEmpty ? order.recipientName : order.buyerName);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ArtisanChatScreen(
          chatId: chat.id,
          artisanId: chat.artisanId,
          buyerId: chat.buyerId,
          buyerName: buyerName,
          orderId: chat.orderId,
          orderTotal: order?.totalAmountLkr,
        ),
      ),
    );
  }

  String _shortId(String id) => id.length > 8 ? id.substring(0, 8) : id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Customer Messages'),
      body: _stream == null
          ? const EmptyStateView(
              icon: Icons.chat_bubble_outline,
              title: 'No shop selected',
              description: 'Sign in as an artisan to see customer messages.',
            )
          : StreamBuilder<List<ConversationModel>>(
              stream: _stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return EmptyStateView(
                    icon: Icons.cloud_off_outlined,
                    title: 'Could not load messages',
                    description: 'Check your connection and try again.',
                    actionButtonText: 'Try again',
                    onActionPressed: _retry,
                  );
                }
                if (!snapshot.hasData) {
                  return const LoadingIndicator(message: 'Loading messages...');
                }

                final chats = snapshot.data!;
                if (chats.isEmpty) {
                  return const EmptyStateView(
                    icon: Icons.chat_bubble_outline,
                    title: 'No messages yet',
                    description: 'When a buyer messages you about an order, the chat will appear here.',
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: chats.length,
                  separatorBuilder: (_, i) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    final order = _findOrder(chat.orderId);
                    final who = order == null
                        ? 'Customer'
                        : (order.recipientName.isNotEmpty ? order.recipientName : order.buyerName);
                    final title = chat.orderId != null
                        ? 'Order #${_shortId(chat.orderId!)} - $who'
                        : who;
                    final when = chat.lastMessageAt ?? chat.createdAt;

                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                          child: Icon(
                            chat.type == ConversationType.order
                                ? Icons.receipt_long
                                : Icons.inventory_2_outlined,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            chat.lastMessage.isNotEmpty ? chat.lastMessage : 'No messages yet',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
                          ),
                        ),
                        trailing: Text(
                          DateTimeUtils.formatChatTimestamp(when),
                          style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                        ),
                        onTap: () => _openChat(chat),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
