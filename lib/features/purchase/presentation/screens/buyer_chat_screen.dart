import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../state/buyer_chat_provider.dart';
import '../widgets/chat_bubble.dart';

/// Assigned to: DISSANAYAKE D. M. S. D.
/// Branch: feature/buyer-purchase
class BuyerChatScreen extends StatefulWidget {
  final String chatId;
  final String artisanId;
  final String artisanName;
  final String buyerId;

  const BuyerChatScreen({
    Key? key,
    required this.chatId,
    required this.artisanId,
    required this.artisanName,
    required this.buyerId,
  }) : super(key: key);

  @override
  State<BuyerChatScreen> createState() => _BuyerChatScreenState();
}

class _BuyerChatScreenState extends State<BuyerChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BuyerChatProvider()..listenToMessages(widget.chatId),
      child: Consumer<BuyerChatProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            appBar: CustomAppBar(
              title: widget.artisanName,
              actions: [
                IconButton(
                  icon: const Icon(Icons.info_outline, color: AppColors.textPrimary),
                  onPressed: () {},
                ),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: provider.isLoading
                      ? const LoadingIndicator(message: 'Loading conversation...')
                      : provider.messages.isEmpty
                          ? const EmptyStateView(
                              icon: Icons.chat_bubble_outline,
                              title: 'Ask the Artisan',
                              description:
                                  'Inquire about custom sizing, materials, or dispatch times.',
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                              itemCount: provider.messages.length,
                              itemBuilder: (context, index) {
                                final msg = provider.messages[index];
                                final isMe = msg.senderId == widget.buyerId;
                                return ChatBubble(message: msg, isMe: isMe);
                              },
                            ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    border: Border(top: BorderSide(color: AppColors.border)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: const InputDecoration(
                            hintText: 'Type your inquiry...',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send, color: AppColors.primary),
                        onPressed: () {
                          final text = _messageController.text.trim();
                          if (text.isNotEmpty) {
                            provider.sendChatMessage(
                              chatId: widget.chatId,
                              senderId: widget.buyerId,
                              receiverId: widget.artisanId,
                              text: text,
                            );
                            _messageController.clear();
                          }
                        },
                      ),
                    ],
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
