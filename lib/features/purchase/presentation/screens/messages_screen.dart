import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/tr.dart';
import '../../../../core/shared_models/conversation_model.dart';
import '../../../../core/shared_models/order_model.dart';
import '../../../../core/utils/date_time_utils.dart';
import '../../../account/presentation/state/auth_provider.dart';
import '../../data/datasources/buyer_chat_remote_datasource.dart';
import '../../data/datasources/buyer_orders_remote_datasource.dart';
import '../widgets/order_text.dart';
import '../widgets/purchase_parts.dart';

/// Assigned to: DISSANAYAKE D. M. S. D.
/// Branch: feature/buyer-purchase
// I09 Messages (hi-fi HF15), opened from My Orders, not a tab
// every chat here is for one of the buyer's orders
class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final _search = TextEditingController();
  String? _uid;
  Stream<List<ConversationModel>>? _chats;
  Stream<List<OrderModel>>? _orders;

  void _listen(String? uid) {
    if (uid == _uid) return;
    _uid = uid;
    _chats = uid == null
        ? null
        : BuyerChatRemoteDataSource().streamBuyerConversations(uid);
    _orders = uid == null
        ? null
        : BuyerOrdersRemoteDataSource().streamBuyerOrders(uid);
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _listen(context.watch<AuthProvider>().currentUser?.uid);
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('pur_messages')), centerTitle: true),
      body: SafeArea(
        child: (_chats == null || _orders == null)
            ? const SizedBox.shrink()
            : StreamBuilder<List<OrderModel>>(
                stream: _orders,
                builder: (context, orderSnap) {
                  return StreamBuilder<List<ConversationModel>>(
                    stream: _chats,
                    builder: (context, chatSnap) {
                      if (chatSnap.hasError || orderSnap.hasError) {
                        return _hint(context.tr('pur_chats_load_error'));
                      }
                      if (!chatSnap.hasData || !orderSnap.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final orders = {for (final o in orderSnap.data!) o.id: o};
                      final query = _search.text.trim().toLowerCase();
                      final rows = chatSnap.data!
                          .where((c) =>
                              c.type == ConversationType.order &&
                              orders.containsKey(c.orderId))
                          .where((c) {
                        if (query.isEmpty) return true;
                        final o = orders[c.orderId]!;
                        return o.artisanName.toLowerCase().contains(query) ||
                            OrderText.ref(o.id).toLowerCase().contains(query) ||
                            o.items.any(
                                (i) => i.title.toLowerCase().contains(query));
                      }).toList();

                      return ListView(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        children: [
                          Text(context.tr('pur_messages_sub'),
                              style: const TextStyle(
                                  color: AppColors.textSecondary)),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _search,
                            onChanged: (_) => setState(() {}),
                            decoration: InputDecoration(
                              hintText: context.tr('pur_search_chats'),
                              prefixIcon: const Icon(Icons.search),
                            ),
                          ),
                          const SizedBox(height: 14),
                          if (rows.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 32),
                              child: _hint(context.tr(query.isEmpty
                                  ? 'pur_no_chats'
                                  : 'pur_no_chat_match')),
                            )
                          else
                            for (final chat in rows)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _ChatRow(
                                  chat: chat,
                                  order: orders[chat.orderId]!,
                                ),
                              ),
                          const SizedBox(height: 6),
                          InfoNote(
                            icon: Icons.forum_outlined,
                            title: context.tr('pur_order_chats_title'),
                            text: context.tr('pur_order_chats_text'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
      ),
    );
  }

  Widget _hint(String text) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.chat_bubble_outline,
                size: 52, color: AppColors.textMuted),
            const SizedBox(height: 12),
            Text(text,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _ChatRow extends StatelessWidget {
  final ConversationModel chat;
  final OrderModel order;

  const _ChatRow({required this.chat, required this.order});

  @override
  Widget build(BuildContext context) {
    final name = order.artisanName.isEmpty
        ? context.tr('pur_artisan')
        : order.artisanName;
    final when = chat.lastMessageAt;
    return InkWell(
      onTap: () =>
          Navigator.pushNamed(context, AppRoutes.buyerChat, arguments: order.id),
      borderRadius: BorderRadius.circular(16),
      child: PurchaseCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primary.withValues(alpha: 0.12),
              child: Text(
                name.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 18),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700)),
                      ),
                      if (when != null)
                        Text(DateTimeUtils.formatChatTimestamp(when),
                            style: const TextStyle(
                                fontSize: 11, color: AppColors.textMuted)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  SmallBadge(
                    text: '${context.tr('pur_order_ref', {
                          'ref': OrderText.ref(order.id)
                        })} · ${OrderText.itemsTitle(context, order.items)}',
                    color: AppColors.primary,
                    icon: Icons.shopping_bag_outlined,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    chat.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textSecondary),
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
