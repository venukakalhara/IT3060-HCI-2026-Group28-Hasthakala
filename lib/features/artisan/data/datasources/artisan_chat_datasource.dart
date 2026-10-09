import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/services/firebase/firestore_service.dart';
import '../../../../core/shared_models/chat_message_model.dart';
import '../../../../core/shared_models/conversation_model.dart';
import '../../../../core/utils/firestore_converters.dart';

/// Assigned to: KUMARI R. P. G. D.
/// Branch: feature/artisan-management
class ArtisanChatDataSource {
  final FirestoreService _firestoreService;

  ArtisanChatDataSource({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

  Stream<List<ChatMessageModel>> streamConversation(String conversationId) {
    return _firestoreService.instance
        .collection(FirestoreCollections.conversationMessages(conversationId))
        .orderBy('sentAt', descending: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ChatMessageModel.fromMap(doc.data(), doc.id)).toList());
  }

  Future<ConversationModel?> getConversation(String conversationId) async {
    final doc = await _firestoreService.getDocument(
      collection: FirestoreCollections.conversations,
      docId: conversationId,
    );
    if (!doc.exists || doc.data() == null) return null;
    return ConversationModel.fromMap(doc.data()!, doc.id);
  }

  // I09 artisan inbox: every chat that belongs to this shop, newest first.
  // Filtered by artisanId so the security rules can check the whole list.
  Stream<List<ConversationModel>> streamArtisanConversations(String artisanId) {
    return _firestoreService.instance
        .collection(FirestoreCollections.conversations)
        .where('artisanId', isEqualTo: artisanId)
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs
          .map((doc) => ConversationModel.fromMap(doc.data(), doc.id))
          .toList();
      list.sort((a, b) =>
          (b.lastMessageAt ?? b.createdAt).compareTo(a.lastMessageAt ?? a.createdAt));
      return list;
    });
  }

  // Saves the reply and moves the chat's last message along in one batch.
  // If the buyer already started the chat, only lastMessage and lastMessageAt
  // change (that is all the rules allow). If the artisan writes first, the
  // chat document is created with every field, same as the buyer side.
  Future<void> replyToBuyer({
    required String conversationId,
    required ChatMessageModel message,
    ConversationType? type,
    String? orderId,
    String? productId,
    String? buyerId,
    String? artisanId,
  }) async {
    final db = _firestoreService.instance;
    final conversationRef =
        db.collection(FirestoreCollections.conversations).doc(conversationId);
    final messageRef = db
        .collection(FirestoreCollections.conversationMessages(conversationId))
        .doc();
    final sentAt = FirestoreConverters.toTimestamp(message.timestamp);

    final existing = await conversationRef.get();

    final messageData = message.toMap();
    messageData['messageId'] = messageRef.id;

    final batch = db.batch();
    batch.set(messageRef, messageData);
    if (existing.exists) {
      batch.update(conversationRef, {
        'lastMessage': message.content,
        'lastMessageAt': sentAt,
      });
    } else {
      batch.set(conversationRef, {
        'conversationId': conversationId,
        'type': type == ConversationType.productQuery ? 'product_query' : 'order',
        'orderId': orderId,
        'productId': productId,
        'buyerId': buyerId ?? '',
        'artisanId': artisanId ?? '',
        'lastMessage': message.content,
        'lastMessageAt': sentAt,
        'createdAt': sentAt,
      });
    }
    await batch.commit();
  }
}
