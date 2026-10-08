import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/services/firebase/firestore_service.dart';
import '../../../../core/shared_models/artisan_profile_model.dart';
import '../../../../core/shared_models/support_models.dart';

/// Works out which contexts a signed-in person has (decision D1):
/// buyer (always), artisan (has artisanProfiles/{uid}),
/// supporter (has an active supportGrants document).
class ContextRemoteDataSource {
  final FirestoreService _firestoreService;

  ContextRemoteDataSource({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

  Future<bool> hasArtisanProfile(String uid) async {
    final doc = await _firestoreService.getDocument(
      collection: FirestoreCollections.artisanProfiles,
      docId: uid,
    );
    return doc.exists;
  }

  Future<List<SupportGrantModel>> activeGrantsFor(String supporterUid) async {
    final snapshot = await _firestoreService.instance
        .collection(FirestoreCollections.supportGrants)
        .where('supporterId', isEqualTo: supporterUid)
        .where('status', isEqualTo: SupportGrantStatus.active.name)
        .get();
    return snapshot.docs
        .map((doc) => SupportGrantModel.fromMap(doc.data()))
        .toList();
  }

  /// CREATE artisanProfiles/{uid} (I05 first-time artisan setup).
  Future<void> createArtisanProfile(ArtisanProfileModel profile) async {
    await _firestoreService.setDocument(
      collection: FirestoreCollections.artisanProfiles,
      docId: profile.artisanUid,
      data: profile.toMap(),
      merge: false,
    );
  }
}
