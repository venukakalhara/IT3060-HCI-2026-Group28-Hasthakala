import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/shared_models/order_model.dart';
import '../delivery_details.dart';

/// Assigned to: DISSANAYAKE D. M. S. D.
/// Branch: feature/buyer-purchase
// an item ran out of stock or was hidden during checkout
class OutOfStockException implements Exception {
  final List<String> titles;
  OutOfStockException(this.titles);
}

// I07 - saves the orders
class CheckoutRemoteDataSource {
  final FirebaseFirestore _db;

  CheckoutRemoteDataSource({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  // one order per artisan (S2), all saved together in one batch.
  // products are read from the server first to check the stock,
  // this also stops early when there is no internet
  Future<List<OrderModel>> placeOrders({
    required String buyerId,
    required String buyerName,
    required List<OrderItemModel> items,
    required DeliveryDetails address,
    required String paymentMethod,
    required double deliveryFee,
    String? deliveryNote,
  }) async {
    final artisanNames = <String, String>{};
    final soldOut = <String>[];
    for (final item in items) {
      final doc = await _db
          .collection(FirestoreCollections.products)
          .doc(item.productId)
          .get(const GetOptions(source: Source.server))
          .timeout(const Duration(seconds: 15));
      final data = doc.data();
      final stock = (data?['stockQuantity'] as num?)?.toInt() ?? 0;
      if (data == null || data['isAvailable'] == false || stock < item.quantity) {
        soldOut.add(item.title);
      } else {
        artisanNames[item.artisanId] = (data['artisanName'] as String?) ?? '';
      }
    }
    if (soldOut.isNotEmpty) throw OutOfStockException(soldOut);

    final groups = <String, List<OrderItemModel>>{};
    for (final item in items) {
      groups.putIfAbsent(item.artisanId, () => []).add(_orderLine(item));
    }

    // delivery is charged once and split equally between the orders
    final shares = splitFee(deliveryFee, groups.length);
    final now = DateTime.now();
    final batch = _db.batch();
    final orders = <OrderModel>[];
    var i = 0;
    for (final entry in groups.entries) {
      final ref = _db.collection(FirestoreCollections.orders).doc();
      final subtotal =
          entry.value.fold<double>(0.0, (sum, line) => sum + line.lineTotal);
      final fee = shares[i++];
      final order = OrderModel(
        id: ref.id,
        buyerId: buyerId,
        buyerName: buyerName,
        artisanId: entry.key,
        artisanName: artisanNames[entry.key] ?? '',
        items: entry.value,
        subtotal: subtotal,
        deliveryFee: fee,
        totalAmountLkr: subtotal + fee,
        recipientName: address.recipientName,
        shippingAddress: address.addressLine,
        city: address.city,
        district: address.district,
        contactPhone: address.phone,
        paymentMethod: paymentMethod,
        paymentStatus: PaymentStatuses.pending,
        status: OrderStatus.pending,
        statusHistory: [
          OrderStatusChange(status: OrderStatus.pending, at: now, byUid: buyerId),
        ],
        deliveryNote: deliveryNote,
        createdAt: now,
        updatedAt: now,
        updatedBy: buyerId,
      );
      batch.set(ref, order.toMap());
      orders.add(order);
    }
    await batch.commit().timeout(const Duration(seconds: 20));
    return orders;
  }

  // only for the old tracking screen, remove it with that screen
  Stream<OrderModel?> streamOrder(String orderId) {
    return _db
        .collection(FirestoreCollections.orders)
        .doc(orderId)
        .snapshots()
        .map((doc) => doc.exists && doc.data() != null
            ? OrderModel.fromMap(doc.data()!, doc.id)
            : null);
  }

  // when "save as my delivery address" is ticked
  Future<void> saveDefaultAddress(String uid, DeliveryDetails address) {
    return _db.collection(FirestoreCollections.users).doc(uid).update({
      'defaultDeliveryAddress': address.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // e.g. Rs. 450 for 2 orders = 225 + 225 (done in cents so it adds up)
  static List<double> splitFee(double fee, int parts) {
    if (parts <= 0) return const [];
    final cents = (fee * 100).round();
    final base = cents ~/ parts;
    final extra = cents - base * parts;
    return List.generate(parts, (i) => (base + (i == 0 ? extra : 0)) / 100);
  }

  // addedAt is only for the cart, not for orders
  static OrderItemModel _orderLine(OrderItemModel item) => OrderItemModel(
        productId: item.productId,
        title: item.title,
        unitPriceLkr: item.unitPriceLkr,
        quantity: item.quantity,
        imageUrl: item.imageUrl,
        artisanId: item.artisanId,
      );
}
