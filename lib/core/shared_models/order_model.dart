import '../utils/firestore_converters.dart';

// order status values (stored as the enum name)
enum OrderStatus {
  pending,
  confirmed,
  preparing,
  shipped,
  delivered,
  cancelled,
}

// values stored in orders.paymentMethod / paymentStatus
class PaymentMethods {
  static const String cashOnDelivery = 'cash_on_delivery';
  static const String bankTransfer = 'bank_transfer';
}

class PaymentStatuses {
  static const String pending = 'pending';
  static const String paid = 'paid';
}

// One line in an order (and one document in users/{uid}/cart).
// Stored fields: productId, artisanId, title, unitPrice, quantity, imageUrl
// (+ addedAt for cart documents only).
class OrderItemModel {
  final String productId;
  final String title;
  final double unitPriceLkr;
  final int quantity;
  final String? imageUrl;
  final String artisanId;
  final DateTime? addedAt;

  OrderItemModel({
    required this.productId,
    required this.title,
    required this.unitPriceLkr,
    required this.quantity,
    this.imageUrl,
    required this.artisanId,
    this.addedAt,
  });

  double get lineTotal => unitPriceLkr * quantity;

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'artisanId': artisanId,
      'title': title,
      'unitPrice': unitPriceLkr,
      'quantity': quantity,
      'imageUrl': imageUrl,
      if (addedAt != null)
        'addedAt': FirestoreConverters.toTimestamp(addedAt!),
    };
  }

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      productId: map['productId'] ?? '',
      title: map['title'] ?? '',
      unitPriceLkr: (map['unitPrice'] as num?)?.toDouble() ?? 0.0,
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
      imageUrl: map['imageUrl'],
      artisanId: map['artisanId'] ?? '',
      addedAt: FirestoreConverters.toDateTimeOrNull(map['addedAt']),
    );
  }
}

// One entry in orders.statusHistory.
class OrderStatusChange {
  final OrderStatus status;
  final DateTime at;
  final String byUid;

  OrderStatusChange({required this.status, required this.at, required this.byUid});

  Map<String, dynamic> toMap() => {
        'status': status.name,
        'at': FirestoreConverters.toTimestamp(at),
        'byUid': byUid,
      };

  factory OrderStatusChange.fromMap(Map<String, dynamic> map) {
    return OrderStatusChange(
      status: OrderStatus.values.firstWhere(
        (s) => s.name == map['status'],
        orElse: () => OrderStatus.pending,
      ),
      at: FirestoreConverters.toDateTime(map['at']),
      byUid: map['byUid'] ?? '',
    );
  }
}

// orders/{orderId} - one order per artisan. Created by I07,
// read by I08, status updated by I12.
// Dart -> stored names: id -> orderId, totalAmountLkr -> total,
// shippingAddress -> deliveryAddress.addressLine,
// contactPhone -> deliveryAddress.phone.
class OrderModel {
  final String id;
  final String buyerId;
  final String buyerName;
  final String artisanId;
  final String artisanName;
  final List<OrderItemModel> items;
  final double subtotal;
  final double deliveryFee;
  final double totalAmountLkr;
  final String recipientName;
  final String shippingAddress;
  final String city;
  final String district;
  final String contactPhone;
  final String paymentMethod;
  final String paymentStatus;
  final OrderStatus status;
  final List<OrderStatusChange> statusHistory;
  final String? deliveryNote;
  final String? cancelReason;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? updatedBy;

  OrderModel({
    required this.id,
    required this.buyerId,
    required this.buyerName,
    this.artisanId = '',
    this.artisanName = '',
    required this.items,
    double? subtotal,
    this.deliveryFee = 0.0,
    required this.totalAmountLkr,
    this.recipientName = '',
    required this.shippingAddress,
    this.city = '',
    this.district = '',
    required this.contactPhone,
    this.paymentMethod = PaymentMethods.cashOnDelivery,
    this.paymentStatus = PaymentStatuses.pending,
    this.status = OrderStatus.pending,
    this.statusHistory = const [],
    this.deliveryNote,
    this.cancelReason,
    this.updatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : subtotal = subtotal ??
            items.fold<double>(0.0, (sum, item) => sum + item.lineTotal),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'orderId': id,
      'buyerId': buyerId,
      'buyerName': buyerName,
      'artisanId': artisanId,
      'artisanName': artisanName,
      'items': items.map((x) => x.toMap()).toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'total': totalAmountLkr,
      'deliveryAddress': {
        'recipientName': recipientName,
        'phone': contactPhone,
        'addressLine': shippingAddress,
        'city': city,
        'district': district,
      },
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'status': status.name,
      'statusHistory': statusHistory.map((x) => x.toMap()).toList(),
      'deliveryNote': deliveryNote,
      'cancelReason': cancelReason,
      'createdAt': FirestoreConverters.toTimestamp(createdAt),
      'updatedAt': FirestoreConverters.toTimestamp(updatedAt),
      'updatedBy': updatedBy,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map, String docId) {
    final address = Map<String, dynamic>.from(map['deliveryAddress'] ?? const {});
    return OrderModel(
      id: docId,
      buyerId: map['buyerId'] ?? '',
      buyerName: map['buyerName'] ?? '',
      artisanId: map['artisanId'] ?? '',
      artisanName: map['artisanName'] ?? '',
      items: (map['items'] as List<dynamic>? ?? const [])
          .map((item) => OrderItemModel.fromMap(Map<String, dynamic>.from(item)))
          .toList(),
      subtotal: (map['subtotal'] as num?)?.toDouble(),
      deliveryFee: (map['deliveryFee'] as num?)?.toDouble() ?? 0.0,
      totalAmountLkr: (map['total'] as num?)?.toDouble() ?? 0.0,
      recipientName: address['recipientName'] ?? '',
      shippingAddress: address['addressLine'] ?? '',
      city: address['city'] ?? '',
      district: address['district'] ?? '',
      contactPhone: address['phone'] ?? '',
      paymentMethod: map['paymentMethod'] ?? PaymentMethods.cashOnDelivery,
      paymentStatus: map['paymentStatus'] ?? PaymentStatuses.pending,
      status: OrderStatus.values.firstWhere(
        (s) => s.name == map['status'],
        orElse: () => OrderStatus.pending,
      ),
      statusHistory: (map['statusHistory'] as List<dynamic>? ?? const [])
          .map((x) => OrderStatusChange.fromMap(Map<String, dynamic>.from(x)))
          .toList(),
      deliveryNote: map['deliveryNote'],
      cancelReason: map['cancelReason'],
      updatedBy: map['updatedBy'],
      createdAt: FirestoreConverters.toDateTime(map['createdAt']),
      updatedAt: FirestoreConverters.toDateTime(map['updatedAt']),
    );
  }
}
