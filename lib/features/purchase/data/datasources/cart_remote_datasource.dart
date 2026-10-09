import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/services/firebase/firestore_service.dart';
import '../../../../core/shared_models/order_model.dart';

/// Assigned to: DISSANAYAKE D. M. S. D.
/// Branch: feature/buyer-purchase
// I06 cart in users/{uid}/cart/{productId} - one document per product.
class CartRemoteDataSource {
  final FirestoreService _firestoreService;

  CartRemoteDataSource({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

  // writes the whole line, so the quantity is always the latest one
  Future<void> addToCart({
    required String userId,
    required OrderItemModel item,
  }) async {
    await _firestoreService.setDocument(
      collection: FirestoreCollections.userCart(userId),
      docId: item.productId,
      data: item.toMap(),
      merge: false,
    );
  }

  // oldest first, so items keep the order they were added in
  Stream<List<OrderItemModel>> streamCartItems(String userId) {
    return _firestoreService
        .streamCollection(collection: FirestoreCollections.userCart(userId))
        .map((snapshot) {
      final items =
          snapshot.docs.map((doc) => OrderItemModel.fromMap(doc.data())).toList();
      items.sort((a, b) => (a.addedAt ?? DateTime(2000))
          .compareTo(b.addedAt ?? DateTime(2000)));
      return items;
    });
  }

  Future<void> removeFromCart({
    required String userId,
    required String productId,
  }) async {
    await _firestoreService.deleteDocument(
      collection: FirestoreCollections.userCart(userId),
      docId: productId,
    );
  }
}
