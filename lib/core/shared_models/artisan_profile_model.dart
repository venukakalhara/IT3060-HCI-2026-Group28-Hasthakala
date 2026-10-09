import '../utils/firestore_converters.dart';

// artisanProfiles/{artisanUid} - I05.
// edited in I05 Manage, shown in the public artisan profile
// `verified` can only be changed by an admin (enforced by security rules).
// Ratings are calculated from `reviews` when displayed, never stored here.
class ArtisanProfileModel {
  final String artisanUid;
  final String displayName;
  final String craftType;
  final String about;
  final String location;
  final String? photoUrl;
  final bool verified;
  final DateTime createdAt;
  final DateTime updatedAt;

  ArtisanProfileModel({
    required this.artisanUid,
    required this.displayName,
    this.craftType = '',
    this.about = '',
    this.location = '',
    this.photoUrl,
    this.verified = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'artisanUid': artisanUid,
      'displayName': displayName,
      'craftType': craftType,
      'about': about,
      'location': location,
      'photoUrl': photoUrl,
      'verified': verified,
      'createdAt': FirestoreConverters.toTimestamp(createdAt),
      'updatedAt': FirestoreConverters.toTimestamp(updatedAt),
    };
  }

  factory ArtisanProfileModel.fromMap(Map<String, dynamic> map, String docId) {
    return ArtisanProfileModel(
      artisanUid: docId,
      displayName: map['displayName'] ?? '',
      craftType: map['craftType'] ?? '',
      about: map['about'] ?? '',
      location: map['location'] ?? '',
      photoUrl: map['photoUrl'],
      verified: map['verified'] ?? false,
      createdAt: FirestoreConverters.toDateTime(map['createdAt']),
      updatedAt: FirestoreConverters.toDateTime(map['updatedAt']),
    );
  }

  ArtisanProfileModel copyWith({
    String? displayName,
    String? craftType,
    String? about,
    String? location,
    String? photoUrl,
    DateTime? updatedAt,
  }) {
    return ArtisanProfileModel(
      artisanUid: artisanUid,
      displayName: displayName ?? this.displayName,
      craftType: craftType ?? this.craftType,
      about: about ?? this.about,
      location: location ?? this.location,
      photoUrl: photoUrl ?? this.photoUrl,
      verified: verified,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
