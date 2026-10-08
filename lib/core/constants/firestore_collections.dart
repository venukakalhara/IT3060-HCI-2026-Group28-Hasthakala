/// LOCKED Firestore collection names - see docs/FIREBASE_SCHEMA.md.
/// Never rename these. New collections may only be ADDED after team agreement.
class FirestoreCollections {
  static const String users = 'users';
  static const String artisanProfiles = 'artisanProfiles';
  static const String products = 'products';
  static const String orders = 'orders';
  static const String conversations = 'conversations';
  static const String messages = 'messages';
  static const String reviews = 'reviews';
  static const String supportGrants = 'supportGrants';
  static const String supportInvites = 'supportInvites';
  static const String admins = 'admins';
  static const String cart = 'cart';

  /// users/{uid}/cart - one document per product (I06).
  static String userCart(String userId) => '$users/$userId/$cart';

  /// conversations/{conversationId}/messages (I09).
  static String conversationMessages(String conversationId) =>
      '$conversations/$conversationId/$messages';

  /// Order chat uses the orderId as its conversation ID.
  static String orderConversationId(String orderId) => orderId;

  /// Product question chat: one per product per buyer.
  static String productQueryConversationId(String productId, String buyerId) =>
      '${productId}_$buyerId';

  /// supportGrants/{artisanUid}_{supporterUid} (I13).
  static String supportGrantId(String artisanId, String supporterId) =>
      '${artisanId}_$supporterId';

  /// reviews/{orderId}_{productId} - one review per product per order.
  static String reviewId(String orderId, String productId) =>
      '${orderId}_$productId';

  @Deprecated('Use conversationMessages(). Chats must be order/product linked (I09).')
  static String chatMessages(String chatId) => conversationMessages(chatId);

  @Deprecated('Replaced by supportGrants/supportInvites (I13). Writes here are blocked by security rules.')
  static const String familyPermissions = 'family_permissions';
}
