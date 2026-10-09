import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/shared_models/conversation_model.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../account/presentation/state/auth_provider.dart';
import '../../../purchase/presentation/widgets/chat_bubble.dart';
import '../state/artisan_chat_provider.dart';

/// Assigned to: KUMARI R. P. G. D.
/// Branch: feature/artisan-management
class ArtisanChatScreen extends StatefulWidget {
  final String chatId;
  final String artisanId;
  final String buyerId;
  final String buyerName;
  final String? orderId;
  final double? orderTotal;
  final String? productTitle;
  final double? productPrice;

  const ArtisanChatScreen({
    super.key,
    required this.chatId,
    required this.artisanId,
    required this.buyerId,
    required this.buyerName,
    this.orderId,
    this.orderTotal,
    this.productTitle,
    this.productPrice,
  });

  @override
  State<ArtisanChatScreen> createState() => _ArtisanChatScreenState();
}

class _ArtisanChatScreenState extends State<ArtisanChatScreen> {
  final TextEditingController _replyController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _replyController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  void _send(ArtisanChatProvider provider, String text) async {
    final auth = context.read<AuthProvider>();
    final effectiveArtisanId = widget.artisanId.isNotEmpty && widget.artisanId != 'sample_artisan_id'
        ? widget.artisanId
        : (auth.actingArtisanId ?? auth.currentUser?.uid ?? '');
    final senderName = auth.currentUser?.displayName ?? 'Artisan';
    final senderContext = auth.isSupporterContext ? 'supporter' : 'artisan';

    final conversationType = widget.orderId != null
        ? ConversationType.order
        : ConversationType.productQuery;

    final success = await provider.sendReply(
      chatId: widget.chatId,
      artisanId: effectiveArtisanId,
      buyerId: widget.buyerId,
      replyText: text,
      senderName: senderName,
      senderContext: senderContext,
      conversationType: conversationType,
      orderId: widget.orderId,
      productId: widget.productTitle != null ? widget.chatId : null,
    );

    if (success) {
      _replyController.clear();
      Future.delayed(const Duration(milliseconds: 150), _scrollToBottom);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ArtisanChatProvider()..listenToMessages(widget.chatId),
      child: Consumer<ArtisanChatProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            appBar: CustomAppBar(
              title: widget.buyerName.isNotEmpty ? widget.buyerName : 'Customer Inquiry',
            ),
            body: Column(
              children: [
                // Context Banner (Order or Product Linked)
                if (widget.orderId != null || widget.productTitle != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      border: Border(bottom: BorderSide(color: AppColors.border)),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                          child: Icon(
                            widget.orderId != null ? Icons.receipt_long : Icons.inventory_2_outlined,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.orderId != null
                                    ? 'Order #${widget.orderId}'
                                    : '${widget.productTitle}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              if (widget.orderTotal != null)
                                Text(
                                  'Order Total: ${CurrencyFormatter.formatLKR(widget.orderTotal!)}',
                                  style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                                ),
                              if (widget.productPrice != null)
                                Text(
                                  'Price: ${CurrencyFormatter.formatLKR(widget.productPrice!)}',
                                  style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                                ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            widget.orderId != null ? 'ORDER CHAT' : 'PRODUCT QUERY',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondaryDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Messages stream
                Expanded(
                  child: provider.isLoading
                      ? const LoadingIndicator(message: 'Loading conversation...')
                      : provider.messages.isEmpty
                          ? EmptyStateView(
                              icon: Icons.chat_bubble_outline,
                              title: 'No messages yet',
                              description: 'Inquiries and discussions with ${widget.buyerName} will appear here.',
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                              itemCount: provider.messages.length,
                              itemBuilder: (context, index) {
                                final msg = provider.messages[index];
                                final isMe = msg.senderId == widget.artisanId ||
                                    msg.senderContext == 'artisan' ||
                                    msg.senderContext == 'supporter';
                                return ChatBubble(message: msg, isMe: isMe);
                              },
                            ),
                ),

                // Quick response prompts for artisan
                Container(
                  color: AppColors.background,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: ArtisanChatProvider.quickReplies.map((prompt) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ActionChip(
                            backgroundColor: AppColors.surface,
                            side: const BorderSide(color: AppColors.border),
                            label: Text(
                              prompt,
                              style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
                            ),
                            onPressed: () {
                              _replyController.text = prompt;
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                // Message input bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    border: Border(top: BorderSide(color: AppColors.border)),
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _replyController,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: const InputDecoration(
                              hintText: 'Type reply to buyer...',
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            onSubmitted: (val) {
                              if (val.trim().isNotEmpty) {
                                _send(provider, val.trim());
                              }
                            },
                          ),
                        ),
                        IconButton(
                          icon: provider.isSending
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                                )
                              : const Icon(Icons.send, color: AppColors.primary),
                          onPressed: provider.isSending
                              ? null
                              : () {
                                  final text = _replyController.text.trim();
                                  if (text.isNotEmpty) {
                                    _send(provider, text);
                                  }
                                },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
