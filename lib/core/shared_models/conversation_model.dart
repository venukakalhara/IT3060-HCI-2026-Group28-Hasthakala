import '../utils/firestore_converters.dart';

/// Every conversation is tied to an order or a product - never a generic
/// messenger (I09 contract). Stored as 'order' or 'product_query'.
enum ConversationType { order, productQuery }

/// conversations/{conversationId} - I09 (buyer side: Member 2,
/// artisan side: Member 3). ID = orderId for order chats, or
/// '{productId}_{buyerId}' for product questions.
class ConversationModel {
  final String id;
  final ConversationType type;
  final String? orderId;
  final String? productId;
  final String buyerId;
  final String artisanId;
  final String lastMessage;
  final DateTime? lastMessageAt;
  final DateTime createdAt;

  ConversationModel({
    required this.id,
    required this.type,
    this.orderId,
    this.productId,
    required this.buyerId,
    required this.artisanId,
    this.lastMessage = '',
    this.lastMessageAt,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  static String _typeToString(ConversationType t) =>
      t == ConversationType.order ? 'order' : 'product_query';

  Map<String, dynamic> toMap() {
    return {
      'conversationId': id,
      'type': _typeToString(type),
      'orderId': orderId,
      'productId': productId,
      'buyerId': buyerId,
      'artisanId': artisanId,
      'lastMessage': lastMessage,
      'lastMessageAt': FirestoreConverters.toTimestampOrNull(lastMessageAt),
      'createdAt': FirestoreConverters.toTimestamp(createdAt),
    };
  }

  factory ConversationModel.fromMap(Map<String, dynamic> map, String docId) {
    return ConversationModel(
      id: docId,
      type: map['type'] == 'product_query'
          ? ConversationType.productQuery
          : ConversationType.order,
      orderId: map['orderId'],
      productId: map['productId'],
      buyerId: map['buyerId'] ?? '',
      artisanId: map['artisanId'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      lastMessageAt: FirestoreConverters.toDateTimeOrNull(map['lastMessageAt']),
      createdAt: FirestoreConverters.toDateTime(map['createdAt']),
    );
  }
}
