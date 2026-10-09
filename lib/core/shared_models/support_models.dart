import '../utils/firestore_converters.dart';

// the three permissions an artisan can give a supporter
// (account settings always stay with the owner)
class SupportScopes {
  final bool products;
  final bool orders;
  final bool communication;

  SupportScopes copyWith({bool? products, bool? orders, bool? communication}) {
    return SupportScopes(
      products: products ?? this.products,
      orders: orders ?? this.orders,
      communication: communication ?? this.communication,
    );
  }

  bool sameAs(SupportScopes other) =>
      products == other.products &&
      orders == other.orders &&
      communication == other.communication;

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


// Created when a supporter accepts an invite; managed by the artisan.
// The supporter always signs in as themselves; this grant only says what
// they may do for this artisan.
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

  // code of the invite this grant came from (the rules check it)
  final String? inviteCode;

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
    this.inviteCode,
  })  : grantedAt = grantedAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  String get id => '${artisanId}_$supporterId';
  bool get isActive => status == SupportGrantStatus.active;

  // Readable list of permissions, e.g. "Products, Orders".
  String get scopeSummary {
    final parts = <String>[
      if (scopes.products) 'Products',
      if (scopes.orders) 'Orders',
      if (scopes.communication) 'Customer messages',
    ];
    return parts.isEmpty ? 'No permissions' : parts.join(', ');
  }

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
      'inviteCode': inviteCode,
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
      inviteCode: map['inviteCode'],
    );
  }
}

enum SupportInviteStatus { pending, accepted, revoked, expired }

// supportInvites/{code} - the artisan shares the 6-digit code with the supporter
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

  bool get isExpired => DateTime.now().isAfter(expiresAt);

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
