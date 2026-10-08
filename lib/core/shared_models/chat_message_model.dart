import '../utils/firestore_converters.dart';

/// LOCKED message types: free text, or a structured prompt (I09).
enum MessageType { text, prompt }

/// conversations/{conversationId}/messages/{messageId} - I09.
/// LOCKED Firestore field names: see docs/FIREBASE_SCHEMA.md.
/// Dart -> stored names: id -> messageId, content -> text, timestamp -> sentAt.
/// `receiverId` and `productIdReference` are Dart-only (kept for existing
/// code); the order/product context lives on the conversation document.
class ChatMessageModel {
  final String id;
  final String senderId;
  final String senderName;

  /// 'buyer', 'artisan' or 'supporter' (a supporter replies on the artisan's behalf).
  final String senderContext;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final String? receiverId;
  final String? productIdReference;

  ChatMessageModel({
    required this.id,
    required this.senderId,
    this.senderName = '',
    this.senderContext = 'buyer',
    required this.content,
    this.type = MessageType.text,
    DateTime? timestamp,
    this.receiverId,
    this.productIdReference,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'messageId': id,
      'senderId': senderId,
      'senderName': senderName,
      'senderContext': senderContext,
      'text': content,
      'type': type.name,
      'sentAt': FirestoreConverters.toTimestamp(timestamp),
    };
  }

  factory ChatMessageModel.fromMap(Map<String, dynamic> map, String docId) {
    return ChatMessageModel(
      id: docId,
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? '',
      senderContext: map['senderContext'] ?? 'buyer',
      content: map['text'] ?? '',
      type: MessageType.values.firstWhere(
        (t) => t.name == map['type'],
        orElse: () => MessageType.text,
      ),
      timestamp: FirestoreConverters.toDateTime(map['sentAt']),
    );
  }
}
