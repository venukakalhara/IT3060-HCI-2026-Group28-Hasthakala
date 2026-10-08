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

  Future<void> replyToBuyer({
    required String conversationId,
    required ChatMessageModel message,
    ConversationType? type,
    String? orderId,
    String? productId,
    String? buyerId,
    String? artisanId,
  }) async {
    // 1. Add message to subcollection
    await _firestoreService.addDocument(
      collection: FirestoreCollections.conversationMessages(conversationId),
      data: message.toMap(),
    );

    // 2. Update conversation document
    final conversationData = <String, dynamic>{
      'conversationId': conversationId,
      'lastMessage': message.content,
      'lastMessageAt': FirestoreConverters.toTimestamp(message.timestamp),
      if (type != null) 'type': type == ConversationType.order ? 'order' : 'product_query',
      if (orderId != null) 'orderId': orderId,
      if (productId != null) 'productId': productId,
      if (buyerId != null) 'buyerId': buyerId,
      if (artisanId != null) 'artisanId': artisanId,
    };

    await _firestoreService.setDocument(
      collection: FirestoreCollections.conversations,
      docId: conversationId,
      data: conversationData,
      merge: true,
    );
  }
}
