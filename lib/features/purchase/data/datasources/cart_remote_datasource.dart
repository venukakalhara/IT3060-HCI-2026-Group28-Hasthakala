import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/services/firebase/firestore_service.dart';
import '../../../../core/shared_models/order_model.dart';

/// Assigned to: DISSANAYAKE D. M. S. D.
/// Branch: feature/buyer-purchase
class CartRemoteDataSource {
  final FirestoreService _firestoreService;

  CartRemoteDataSource({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

  Future<void> addToCart({
    required String userId,
    required OrderItemModel item,
  }) async {
    await _firestoreService.setDocument(
      collection: FirestoreCollections.userCart(userId),
      docId: item.productId,
      data: item.toMap(),
    );
  }

  Stream<List<OrderItemModel>> streamCartItems(String userId) {
    return _firestoreService
        .streamCollection(collection: FirestoreCollections.userCart(userId))
        .map((snapshot) =>
            snapshot.docs.map((doc) => OrderItemModel.fromMap(doc.data())).toList());
  }

  Future<void> removeFromCart({required String userId, required String productId}) async {
    await _firestoreService.deleteDocument(
      collection: FirestoreCollections.userCart(userId),
      docId: productId,
    );
  }
}
