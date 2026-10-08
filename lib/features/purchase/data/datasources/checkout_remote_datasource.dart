import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/services/firebase/firestore_service.dart';
import '../../../../core/shared_models/order_model.dart';

/// Assigned to: DISSANAYAKE D. M. S. D.
/// Branch: feature/buyer-purchase
class CheckoutRemoteDataSource {
  final FirestoreService _firestoreService;

  CheckoutRemoteDataSource({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

  Future<String> placeOrder(OrderModel order) async {
    final docRef = await _firestoreService.addDocument(
      collection: FirestoreCollections.orders,
      data: order.toMap(),
    );
    return docRef.id;
  }

  Stream<OrderModel?> streamOrder(String orderId) {
    return _firestoreService.instance
        .collection(FirestoreCollections.orders)
        .doc(orderId)
        .snapshots()
        .map((doc) => doc.exists && doc.data() != null
            ? OrderModel.fromMap(doc.data()!, doc.id)
            : null);
  }
}
