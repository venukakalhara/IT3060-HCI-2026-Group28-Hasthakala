import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/services/firebase/firestore_service.dart';
import '../../../../core/shared_models/chat_message_model.dart';

/// Assigned to: DISSANAYAKE D. M. S. D.
/// Branch: feature/buyer-purchase
class BuyerChatRemoteDataSource {
  final FirestoreService _firestoreService;

  BuyerChatRemoteDataSource({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

  Stream<List<ChatMessageModel>> streamMessages(String chatId) {
    return _firestoreService.instance
        .collection(FirestoreCollections.chatMessages(chatId))
        .orderBy('sentAt', descending: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ChatMessageModel.fromMap(doc.data(), doc.id)).toList());
  }

  Future<void> sendMessage(String chatId, ChatMessageModel message) async {
    await _firestoreService.addDocument(
      collection: FirestoreCollections.chatMessages(chatId),
      data: message.toMap(),
    );
  }
}
