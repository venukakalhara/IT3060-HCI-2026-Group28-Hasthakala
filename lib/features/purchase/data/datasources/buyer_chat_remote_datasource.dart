import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/shared_models/chat_message_model.dart';
import '../../../../core/shared_models/conversation_model.dart';
import '../../../../core/shared_models/order_model.dart';
import '../../../../core/utils/firestore_converters.dart';

/// Assigned to: DISSANAYAKE D. M. S. D.
/// Branch: feature/buyer-purchase
// I09 buyer side - an order chat uses the orderId as its id,
// so Member 3's artisan chat reads the same messages
class BuyerChatRemoteDataSource {
  final FirebaseFirestore _db;

  BuyerChatRemoteDataSource({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  Stream<List<ChatMessageModel>> streamMessages(String conversationId) {
    return _db
        .collection(FirestoreCollections.conversationMessages(conversationId))
        .orderBy('sentAt')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessageModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  // latest chat first
  Stream<List<ConversationModel>> streamBuyerConversations(String buyerId) {
    return _db
        .collection(FirestoreCollections.conversations)
        .where('buyerId', isEqualTo: buyerId)
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs
          .map((doc) => ConversationModel.fromMap(doc.data(), doc.id))
          .toList();
      list.sort((a, b) => (b.lastMessageAt ?? b.createdAt)
          .compareTo(a.lastMessageAt ?? a.createdAt));
      return list;
    });
  }

  // saves the message and the chat's last message together
  Future<void> sendOrderMessage({
    required OrderModel order,
    required String senderId,
    required String senderName,
    required String text,
    MessageType type = MessageType.text,
    bool firstMessage = false,
  }) async {
    final conversationId = FirestoreCollections.orderConversationId(order.id);
    final conversationRef =
        _db.collection(FirestoreCollections.conversations).doc(conversationId);
    final messageRef = _db
        .collection(FirestoreCollections.conversationMessages(conversationId))
        .doc();
    final now = DateTime.now();

    final batch = _db.batch();
    batch.set(
      conversationRef,
      {
        'conversationId': conversationId,
        'type': 'order',
        'orderId': order.id,
        'productId': null,
        'buyerId': order.buyerId,
        'artisanId': order.artisanId,
        'lastMessage': text,
        'lastMessageAt': FirestoreConverters.toTimestamp(now),
        if (firstMessage) 'createdAt': FirestoreConverters.toTimestamp(now),
      },
      SetOptions(merge: true),
    );
    batch.set(
      messageRef,
      ChatMessageModel(
        id: messageRef.id,
        senderId: senderId,
        senderName: senderName,
        senderContext: 'buyer',
        content: text,
        type: type,
        timestamp: now,
      ).toMap(),
    );
    await batch.commit();
  }
}
