import '../utils/firestore_converters.dart';

/// The three permissions shown as toggles in the I13 hi-fi:
/// Manage products (I11), Manage orders (I12), Respond to customers (I09).
/// Account/security settings are ALWAYS owner-only and are not a scope.
class SupportScopes {
  final bool products;
  final bool orders;
  final bool communication;

  const SupportScopes({
    this.products = false,
    this.orders = false,
    this.communication = false,
  });

  bool get hasAny => products || orders || communication;

  Map<String, dynamic> toMap() => {
        'products': products,
        'orders': orders,
        'communication': communication,
      };

  factory SupportScopes.fromMap(Map<String, dynamic>? map) {
    final m = map ?? const {};
    return SupportScopes(
      products: m['products'] ?? false,
      orders: m['orders'] ?? false,
      communication: m['communication'] ?? false,
    );
  }
}

enum SupportGrantStatus { active, revoked }

/// supportGrants/{artisanUid}_{supporterUid} - I13 (FR9, NFR3).
/// Created when a supporter accepts an invite; managed by the artisan.
/// The supporter always signs in as THEMSELF; this grant only says what
/// they may do for this artisan.
class SupportGrantModel {
  final String artisanId;
  final String artisanName;
  final String supporterId;
  final String supporterName;
  final String relationship;
  final String phone;
  final SupportScopes scopes;
  final SupportGrantStatus status;
  final DateTime grantedAt;
  final DateTime updatedAt;

  SupportGrantModel({
    required this.artisanId,
    required this.artisanName,
    required this.supporterId,
    required this.supporterName,
    this.relationship = '',
    this.phone = '',
    required this.scopes,
    this.status = SupportGrantStatus.active,
    DateTime? grantedAt,
    DateTime? updatedAt,
  })  : grantedAt = grantedAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  String get id => '${artisanId}_$supporterId';
  bool get isActive => status == SupportGrantStatus.active;

  Map<String, dynamic> toMap() {
    return {
      'artisanId': artisanId,
      'artisanName': artisanName,
      'supporterId': supporterId,
      'supporterName': supporterName,
      'relationship': relationship,
      'phone': phone,
      'scopes': scopes.toMap(),
      'status': status.name,
      'grantedAt': FirestoreConverters.toTimestamp(grantedAt),
      'updatedAt': FirestoreConverters.toTimestamp(updatedAt),
    };
  }

  factory SupportGrantModel.fromMap(Map<String, dynamic> map) {
    return SupportGrantModel(
      artisanId: map['artisanId'] ?? '',
      artisanName: map['artisanName'] ?? '',
      supporterId: map['supporterId'] ?? '',
      supporterName: map['supporterName'] ?? '',
      relationship: map['relationship'] ?? '',
      phone: map['phone'] ?? '',
      scopes: SupportScopes.fromMap(
          map['scopes'] == null ? null : Map<String, dynamic>.from(map['scopes'])),
      status: map['status'] == 'revoked'
          ? SupportGrantStatus.revoked
          : SupportGrantStatus.active,
      grantedAt: FirestoreConverters.toDateTime(map['grantedAt']),
      updatedAt: FirestoreConverters.toDateTime(map['updatedAt']),
    );
  }
}

enum SupportInviteStatus { pending, accepted, revoked, expired }

/// supportInvites/{code} - I13 invitation (decision D4: phone-number form
/// as designed + a 6-digit code the artisan passes to the supporter).
class SupportInviteModel {
  final String code;
  final String artisanId;
  final String artisanName;
  final String inviteeName;
  final String relationship;
  final String phone;
  final SupportScopes scopes;
  final SupportInviteStatus status;
  final DateTime createdAt;
  final DateTime expiresAt;
  final String? acceptedBy;

  SupportInviteModel({
    required this.code,
    required this.artisanId,
    required this.artisanName,
    required this.inviteeName,
    this.relationship = '',
    this.phone = '',
    required this.scopes,
    this.status = SupportInviteStatus.pending,
    DateTime? createdAt,
    DateTime? expiresAt,
    this.acceptedBy,
  })  : createdAt = createdAt ?? DateTime.now(),
        expiresAt = expiresAt ?? DateTime.now().add(const Duration(days: 7));

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'artisanId': artisanId,
      'artisanName': artisanName,
      'inviteeName': inviteeName,
      'relationship': relationship,
      'phone': phone,
      'scopes': scopes.toMap(),
      'status': status.name,
      'createdAt': FirestoreConverters.toTimestamp(createdAt),
      'expiresAt': FirestoreConverters.toTimestamp(expiresAt),
      'acceptedBy': acceptedBy,
    };
  }

  factory SupportInviteModel.fromMap(Map<String, dynamic> map) {
    return SupportInviteModel(
      code: map['code'] ?? '',
      artisanId: map['artisanId'] ?? '',
      artisanName: map['artisanName'] ?? '',
      inviteeName: map['inviteeName'] ?? '',
      relationship: map['relationship'] ?? '',
      phone: map['phone'] ?? '',
      scopes: SupportScopes.fromMap(
          map['scopes'] == null ? null : Map<String, dynamic>.from(map['scopes'])),
      status: SupportInviteStatus.values.firstWhere(
        (s) => s.name == map['status'],
        orElse: () => SupportInviteStatus.pending,
      ),
      createdAt: FirestoreConverters.toDateTime(map['createdAt']),
      expiresAt: FirestoreConverters.toDateTime(map['expiresAt']),
      acceptedBy: map['acceptedBy'],
    );
  }
}
