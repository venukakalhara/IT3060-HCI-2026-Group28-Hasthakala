import 'package:flutter/material.dart';
import '../../../../core/shared_models/chat_message_model.dart';
import '../../data/datasources/buyer_chat_remote_datasource.dart';

/// Assigned to: DISSANAYAKE D. M. S. D.
/// Branch: feature/buyer-purchase
class BuyerChatProvider extends ChangeNotifier {
  final BuyerChatRemoteDataSource _dataSource;

  BuyerChatProvider({BuyerChatRemoteDataSource? dataSource})
      : _dataSource = dataSource ?? BuyerChatRemoteDataSource();

  List<ChatMessageModel> _messages = [];
  bool _isLoading = false;

  List<ChatMessageModel> get messages => _messages;
  bool get isLoading => _isLoading;

  void listenToMessages(String chatId) {
    _isLoading = true;
    notifyListeners();

    _dataSource.streamMessages(chatId).listen((items) {
      _messages = items;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> sendChatMessage({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String text,
    String? productId,
  }) async {
    final message = ChatMessageModel(
      id: '',
      senderId: senderId,
      receiverId: receiverId,
      content: text,
      productIdReference: productId,
    );
    await _dataSource.sendMessage(chatId, message);
  }
}
