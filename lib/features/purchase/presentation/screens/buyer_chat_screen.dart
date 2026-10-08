import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/tr.dart';
import '../../../../core/shared_models/chat_message_model.dart';
import '../../../../core/shared_models/order_model.dart';
import '../../../account/presentation/state/auth_provider.dart';
import '../../data/datasources/buyer_chat_remote_datasource.dart';
import '../../data/datasources/buyer_orders_remote_datasource.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/order_text.dart';
import '../widgets/purchase_parts.dart';
import 'order_tracking_screen.dart';

/// Assigned to: DISSANAYAKE D. M. S. D.
/// Branch: feature/buyer-purchase
// I09 Order chat, buyer side (hi-fi HF16, HF17)
// one chat per order, the artisan replies from their orders (Member 3)
class BuyerChatScreen extends StatefulWidget {
  final String orderId;

  const BuyerChatScreen({super.key, required this.orderId});

  @override
  State<BuyerChatScreen> createState() => _BuyerChatScreenState();
}

class _BuyerChatScreenState extends State<BuyerChatScreen> {
  final _chat = BuyerChatRemoteDataSource();
  late final Stream<OrderModel?> _order =
      BuyerOrdersRemoteDataSource().streamOrder(widget.orderId);
  late final Stream<List<ChatMessageModel>> _messages =
      _chat.streamMessages(widget.orderId);
  final _text = TextEditingController();
  final _scroll = ScrollController();
  int _shownCount = -1;
  bool _hasMessages = false;

  static const _prompts = [
    'pur_prompt_dispatch',
    'pur_prompt_gift',
    'pur_prompt_inscription',
    'pur_prompt_where',
  ];

  @override
  void dispose() {
    _text.dispose();
    _scroll.dispose();
    super.dispose();
  }

  // Firestore shows the message straight away and sends it later if offline,
  // so the text box is cleared first
  Future<void> _send(OrderModel order, String text,
      {MessageType type = MessageType.text}) async {
    final message = text.trim();
    if (message.isEmpty) return;
    final user = context.read<AuthProvider>().currentUser;
    if (user == null) return;
    if (type == MessageType.text) _text.clear();
    try {
      await _chat.sendOrderMessage(
        order: order,
        senderId: user.uid,
        senderName: user.displayName,
        text: message,
        type: type,
        firstMessage: !_hasMessages,
      );
    } catch (_) {
      if (!mounted) return;
      if (type == MessageType.text && _text.text.isEmpty) _text.text = message;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr('pur_send_failed'))),
      );
    }
  }

  void _scrollToEnd(int count) {
    if (count == _shownCount) return;
    _shownCount = count;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.jumpTo(_scroll.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<OrderModel?>(
      stream: _order,
      builder: (context, snapshot) {
        final order = snapshot.data;
        if (order == null) {
          final waiting = snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasError;
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: waiting
                  ? const CircularProgressIndicator()
                  : Text(context.tr('pur_order_missing'),
                      style: const TextStyle(color: AppColors.textSecondary)),
            ),
          );
        }
        final name = order.artisanName.isEmpty
            ? context.tr('pur_artisan')
            : order.artisanName;
        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w700)),
                Text(
                  context.tr('pur_chat_about', {'ref': OrderText.ref(order.id)}),
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: _OrderStrip(order: order),
                ),
                Expanded(child: _messageList(context, order, name)),
                SizedBox(
                  height: 46,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: _prompts.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, i) => ActionChip(
                      avatar: const Icon(Icons.flash_on_outlined,
                          size: 16, color: AppColors.primary),
                      label: Text(context.tr(_prompts[i])),
                      labelStyle: const TextStyle(
                          color: AppColors.primary, fontWeight: FontWeight.w600),
                      backgroundColor: AppColors.surface,
                      side: const BorderSide(color: AppColors.border),
                      onPressed: () => _send(order, context.tr(_prompts[i]),
                          type: MessageType.prompt),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _text,
                          minLines: 1,
                          maxLines: 4,
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (value) => _send(order, value),
                          decoration: InputDecoration(
                            hintText: context.tr('pur_type_message'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        tooltip: context.tr('pur_send'),
                        onPressed: () => _send(order, _text.text),
                        icon: const Icon(Icons.send_rounded),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _messageList(BuildContext context, OrderModel order, String name) {
    final uid = context.watch<AuthProvider>().currentUser?.uid;
    return StreamBuilder<List<ChatMessageModel>>(
      stream: _messages,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(context.tr('pur_chats_load_error'),
                style: const TextStyle(color: AppColors.textSecondary)),
          );
        }
        final messages = snapshot.data ?? const <ChatMessageModel>[];
        _hasMessages = messages.isNotEmpty;
        _scrollToEnd(messages.length);

        final children = <Widget>[
          InfoNote(
            icon: Icons.verified_user_outlined,
            title: context.tr('pur_chat_intro_title'),
            text: context.tr('pur_chat_intro_text', {'name': name}),
          ),
          const SizedBox(height: 8),
        ];
        DateTime? lastDay;
        for (final m in messages) {
          final day = DateUtils.dateOnly(m.timestamp);
          if (lastDay == null || day != lastDay) {
            children.add(_DayChip(day: day));
            lastDay = day;
          }
          final mine = m.senderId == uid;
          children.add(Column(
            crossAxisAlignment:
                mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              if (!mine && m.senderName.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4),
                  child: Text(m.senderName,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textMuted)),
                ),
              ChatBubble(message: m, isMe: mine),
            ],
          ));
        }
        // HF17 - shown after the buyer's own message
        if (messages.isNotEmpty && messages.last.senderId == uid) {
          children.add(Padding(
            padding: const EdgeInsets.only(top: 8),
            child: InfoNote(
              icon: Icons.mark_email_read_outlined,
              title: context.tr('pur_sent_title'),
              text: context.tr('pur_sent_text', {'name': name}),
            ),
          ));
        }
        return ListView(
          controller: _scroll,
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          children: children,
        );
      },
    );
  }
}

class _OrderStrip extends StatelessWidget {
  final OrderModel order;

  const _OrderStrip({required this.order});

  @override
  Widget build(BuildContext context) {
    return PurchaseCard(
      padding: const EdgeInsets.fromLTRB(10, 8, 4, 8),
      child: Row(
        children: [
          ItemThumb(
            imageUrl: order.items.isEmpty ? null : order.items.first.imageUrl,
            size: 40,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${context.tr('pur_order_ref', {
                        'ref': OrderText.ref(order.id)
                      })} · ${OrderText.itemsTitle(context, order.items)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.circle,
                        size: 7, color: AppColors.secondaryDark),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        OrderText.status(context, order.status),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 11.5,
                            color: AppColors.secondaryDark,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => OrderTrackingScreen(orderId: order.id))),
            child: Text(context.tr('pur_view_order')),
          ),
        ],
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  final DateTime day;

  const _DayChip({required this.day});

  @override
  Widget build(BuildContext context) {
    final today = DateUtils.dateOnly(DateTime.now());
    final label = day == today
        ? context.tr('pur_today')
        : (day == today.subtract(const Duration(days: 1))
            ? context.tr('pur_yesterday')
            : OrderText.date(context, day));
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.border.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label,
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ),
    );
  }
}
