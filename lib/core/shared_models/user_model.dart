import '../utils/firestore_converters.dart';

/// Answer to "How will you start using HASTHAKALA?" (I01 onboarding).
/// This is NOT a permission. What a user may do is decided by their
/// contexts (artisan profile, support grants) and enforced by
/// Firestore security rules (NFR3).
enum AccountPurpose { shop, sell }

/// users/{uid} - LOCKED field names, see docs/FIREBASE_SCHEMA.md.
class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String? phone;
  final String? photoUrl;
  final AccountPurpose primaryPurpose;
  final String preferredLanguage;
  final Map<String, dynamic>? defaultDeliveryAddress;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.phone,
    this.photoUrl,
    this.primaryPurpose = AccountPurpose.shop,
    this.preferredLanguage = 'en',
    this.defaultDeliveryAddress,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  bool get startedAsSeller => primaryPurpose == AccountPurpose.sell;

  @Deprecated('Not part of users/{uid}. Use ArtisanProfileModel.location.')
  String? get district => null;

  @Deprecated('Not part of users/{uid}. Use ArtisanProfileModel.about.')
  String? get bio => null;

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'phone': phone,
      'photoUrl': photoUrl,
      'primaryPurpose': primaryPurpose.name,
      'preferredLanguage': preferredLanguage,
      'defaultDeliveryAddress': defaultDeliveryAddress,
      'createdAt': FirestoreConverters.toTimestamp(createdAt),
      'updatedAt': FirestoreConverters.toTimestamp(updatedAt),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String docId) {
    // Early test accounts stored 'role' instead of 'primaryPurpose'.
    final purposeName =
        map['primaryPurpose'] ?? (map['role'] == 'artisan' ? 'sell' : 'shop');
    final address = map['defaultDeliveryAddress'];
    return UserModel(
      uid: docId,
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      phone: map['phone'],
      photoUrl: map['photoUrl'],
      primaryPurpose: AccountPurpose.values.firstWhere(
        (p) => p.name == purposeName,
        orElse: () => AccountPurpose.shop,
      ),
      preferredLanguage: map['preferredLanguage'] ?? 'en',
      defaultDeliveryAddress:
          address == null ? null : Map<String, dynamic>.from(address),
      createdAt: FirestoreConverters.toDateTime(map['createdAt']),
      updatedAt: FirestoreConverters.toDateTime(map['updatedAt']),
    );
  }
}
