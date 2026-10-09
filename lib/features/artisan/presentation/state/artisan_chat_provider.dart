import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/shared_models/chat_message_model.dart';
import '../../../../core/shared_models/conversation_model.dart';
import '../../data/datasources/artisan_chat_datasource.dart';

/// Assigned to: KUMARI R. P. G. D.
/// Branch: feature/artisan-management
class ArtisanChatProvider extends ChangeNotifier {
  final ArtisanChatDataSource _dataSource;
  StreamSubscription<List<ChatMessageModel>>? _messagesSubscription;

  ArtisanChatProvider({ArtisanChatDataSource? dataSource})
      : _dataSource = dataSource ?? ArtisanChatDataSource();

  List<ChatMessageModel> _messages = [];
  bool _isLoading = false;
  bool _isSending = false;
  String? _errorMessage;

  List<ChatMessageModel> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;
  bool get isSending => _isSending;
  String? get errorMessage => _errorMessage;

  static const List<String> quickReplies = [
    'Hello! Thank you for inquiring about this handcrafted creation.',
    'I am currently working on this order in my workshop.',
    'Your craft item has been securely packed and will be dispatched soon.',
    'Custom requests take approximately 3-5 days to craft.',
    'Ayubowan! Thank you for supporting Sri Lankan heritage crafts.',
  ];

  void listenToMessages(String conversationId) {
    _messagesSubscription?.cancel();
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    _messagesSubscription = _dataSource.streamConversation(conversationId).listen(
      (items) {
        _messages = items;
        _isLoading = false;
        notifyListeners();
      },
      onError: (e) {
        _isLoading = false;
        _errorMessage = 'Could not load messages: $e';
        notifyListeners();
      },
    );
  }

  Future<bool> sendReply({
    required String chatId,
    required String artisanId,
    required String buyerId,
    required String replyText,
    String senderName = 'Artisan',
    String senderContext = 'artisan',
    ConversationType? conversationType,
    String? orderId,
    String? productId,
  }) async {
    if (replyText.trim().isEmpty) return false;

    _isSending = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final message = ChatMessageModel(
        id: '',
        senderId: artisanId,
        senderName: senderName,
        senderContext: senderContext,
        receiverId: buyerId,
        content: replyText.trim(),
        type: MessageType.text,
        productIdReference: productId,
      );

      await _dataSource.replyToBuyer(
        conversationId: chatId,
        message: message,
        type: conversationType,
        orderId: orderId,
        productId: productId,
        buyerId: buyerId,
        artisanId: artisanId,
      );

      _isSending = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isSending = false;
      _errorMessage = 'Failed to send message: $e';
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _messagesSubscription?.cancel();
    super.dispose();
  }
}
