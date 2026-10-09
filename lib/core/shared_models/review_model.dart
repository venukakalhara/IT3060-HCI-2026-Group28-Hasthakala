import '../utils/firestore_converters.dart';

// reviews/{orderId}_{productId}. Created by the buyer of a delivered
// order; shown on I04/I05.
class ReviewModel {
  final String orderId;
  final String productId;
  final String artisanId;
  final String buyerId;
  final String buyerName;
  final int rating; // 1 to 5
  final String comment;
  final DateTime createdAt;

  ReviewModel({
    required this.orderId,
    required this.productId,
    required this.artisanId,
    required this.buyerId,
    required this.buyerName,
    required this.rating,
    this.comment = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  String get id => '${orderId}_$productId';

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'productId': productId,
      'artisanId': artisanId,
      'buyerId': buyerId,
      'buyerName': buyerName,
      'rating': rating,
      'comment': comment,
      'createdAt': FirestoreConverters.toTimestamp(createdAt),
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      orderId: map['orderId'] ?? '',
      productId: map['productId'] ?? '',
      artisanId: map['artisanId'] ?? '',
      buyerId: map['buyerId'] ?? '',
      buyerName: map['buyerName'] ?? '',
      rating: (map['rating'] as num?)?.toInt() ?? 0,
      comment: map['comment'] ?? '',
      createdAt: FirestoreConverters.toDateTime(map['createdAt']),
    );
  }
}
