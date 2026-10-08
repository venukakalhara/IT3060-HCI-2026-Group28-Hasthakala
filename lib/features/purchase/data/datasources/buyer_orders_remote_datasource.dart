import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/shared_models/order_model.dart';

/// Assigned to: DISSANAYAKE D. M. S. D.
/// Branch: feature/buyer-purchase
// I08 - the buyer's orders, the artisan changes the status (I12)
class BuyerOrdersRemoteDataSource {
  final FirebaseFirestore _db;

  BuyerOrdersRemoteDataSource({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  // newest first, sorted here so no extra Firestore index is needed
  Stream<List<OrderModel>> streamBuyerOrders(String buyerId) {
    return _db
        .collection(FirestoreCollections.orders)
        .where('buyerId', isEqualTo: buyerId)
        .snapshots()
        .map((snapshot) {
      final orders = snapshot.docs
          .map((doc) => OrderModel.fromMap(doc.data(), doc.id))
          .toList();
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return orders;
    });
  }

  Stream<OrderModel?> streamOrder(String orderId) {
    return _db
        .collection(FirestoreCollections.orders)
        .doc(orderId)
        .snapshots()
        .map((doc) {
      final data = doc.data();
      return data == null ? null : OrderModel.fromMap(data, doc.id);
    });
  }
}
