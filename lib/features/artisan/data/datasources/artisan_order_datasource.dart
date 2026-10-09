import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/services/firebase/firestore_service.dart';
import '../../../../core/shared_models/order_model.dart';
import '../../../../core/utils/firestore_converters.dart';

/// Assigned to: KUMARI R. P. G. D.
/// Branch: feature/artisan-management
class ArtisanOrderDataSource {
  final FirestoreService _firestoreService;

  ArtisanOrderDataSource({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

  Stream<List<OrderModel>> getArtisanOrders(String artisanId) {
    return _firestoreService
        .streamCollection(
          collection: FirestoreCollections.orders,
          queryBuilder: (q) => q.where('artisanId', isEqualTo: artisanId),
        )
        .map((snapshot) =>
            snapshot.docs.map((doc) => OrderModel.fromMap(doc.data(), doc.id)).toList());
  }

  @Deprecated('Use getArtisanOrders(artisanId). Orders must be scoped to the artisan.')
  Stream<List<OrderModel>> getIncomingOrders() {
    return _firestoreService
        .streamCollection(collection: FirestoreCollections.orders)
        .map((snapshot) =>
            snapshot.docs.map((doc) => OrderModel.fromMap(doc.data(), doc.id)).toList());
  }

  Future<OrderModel?> getOrder(String orderId) async {
    final doc = await _firestoreService.getDocument(
      collection: FirestoreCollections.orders,
      docId: orderId,
    );
    if (!doc.exists || doc.data() == null) return null;
    return OrderModel.fromMap(doc.data()!, doc.id);
  }

  Future<void> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
    String? updatedByUid,
    String? cancelReason,
  }) async {
    final now = DateTime.now();
    final historyEntry = OrderStatusChange(
      status: status,
      at: now,
      byUid: updatedByUid ?? '',
    );

    // Fetch existing order doc to append to statusHistory
    final doc = await _firestoreService.getDocument(
      collection: FirestoreCollections.orders,
      docId: orderId,
    );

    List<Map<String, dynamic>> existingHistory = [];
    if (doc.exists && doc.data() != null) {
      final rawList = doc.data()!['statusHistory'] as List<dynamic>?;
      if (rawList != null) {
        existingHistory = rawList.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      }
    }
    existingHistory.add(historyEntry.toMap());

    final updateData = <String, dynamic>{
      'status': status.name,
      'statusHistory': existingHistory,
      'updatedAt': FirestoreConverters.toTimestamp(now),
      if (updatedByUid != null && updatedByUid.isNotEmpty) 'updatedBy': updatedByUid,
      if (cancelReason != null) 'cancelReason': cancelReason,
    };

    await _firestoreService.setDocument(
      collection: FirestoreCollections.orders,
      docId: orderId,
      data: updateData,
      merge: true,
    );
  }
}
