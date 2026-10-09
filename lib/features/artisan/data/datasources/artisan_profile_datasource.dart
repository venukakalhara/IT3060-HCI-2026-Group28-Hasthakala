import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/services/firebase/firestore_service.dart';
import '../../../../core/shared_models/artisan_profile_model.dart';
import '../../../../core/utils/firestore_converters.dart';

/// I05 & FR1: Artisan Profile Datasource.
/// Interacts with `artisanProfiles/{artisanUid}` according to the locked schema:
/// artisanUid, displayName, craftType, about, location, photoUrl, verified, createdAt, updatedAt.
class ArtisanProfileDatasource {
  final FirestoreService _firestoreService;

  ArtisanProfileDatasource({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

  /// Fetch artisan profile document by UID
  Future<ArtisanProfileModel?> getProfile(String artisanUid) async {
    final doc = await _firestoreService.getDocument(
      collection: FirestoreCollections.artisanProfiles,
      docId: artisanUid,
    );
    if (!doc.exists || doc.data() == null) {
      return null;
    }
    return ArtisanProfileModel.fromMap(doc.data()!, doc.id);
  }

  /// Watch live artisan profile document changes
  Stream<ArtisanProfileModel?> watchProfile(String artisanUid) {
    return _firestoreService.instance
        .collection(FirestoreCollections.artisanProfiles)
        .doc(artisanUid)
        .snapshots()
        .map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return ArtisanProfileModel.fromMap(doc.data()!, doc.id);
    });
  }

  /// Create or update artisan profile document.
  /// Complies strictly with firestore.rules:
  /// - Create: artisanUid == auth.uid && verified == false
  /// - Update: !('verified' in changed()) && !('artisanUid' in changed())
  Future<void> saveProfile(ArtisanProfileModel profile) async {
    final docRef = _firestoreService.instance
        .collection(FirestoreCollections.artisanProfiles)
        .doc(profile.artisanUid);

    final snapshot = await docRef.get();

    if (!snapshot.exists) {
      // First-time profile creation (FR1)
      final data = {
        'artisanUid': profile.artisanUid,
        'displayName': profile.displayName,
        'craftType': profile.craftType,
        'about': profile.about,
        'location': profile.location,
        'photoUrl': profile.photoUrl,
        'verified': false,
        'createdAt': FirestoreConverters.toTimestamp(profile.createdAt),
        'updatedAt': FirestoreConverters.toTimestamp(DateTime.now()),
      };
      await docRef.set(data);
    } else {
      // Profile update (I05) - never touch 'verified' or 'artisanUid'
      final Map<String, dynamic> updateData = {
        'displayName': profile.displayName,
        'craftType': profile.craftType,
        'about': profile.about,
        'location': profile.location,
        'photoUrl': profile.photoUrl,
        'updatedAt': Timestamp.now(),
      };
      await docRef.update(updateData);
    }
  }
}
