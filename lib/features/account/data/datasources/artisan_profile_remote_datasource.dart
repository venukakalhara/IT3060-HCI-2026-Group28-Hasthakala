import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/shared_models/artisan_profile_model.dart';

// I05 manage profile - reads and updates artisanProfiles/{uid}
class ArtisanProfileRemoteDataSource {
  final FirebaseFirestore _db;

  ArtisanProfileRemoteDataSource({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      _db.collection(FirestoreCollections.artisanProfiles).doc(uid);

  Stream<ArtisanProfileModel?> watchProfile(String uid) {
    return _doc(uid).snapshots().map((d) =>
        d.exists && d.data() != null ? ArtisanProfileModel.fromMap(d.data()!, d.id) : null);
  }

  // cover style is kept apart from the edit form, so saving one never touches the other
  Stream<String?> watchCoverStyle(String uid) {
    return _doc(uid).snapshots().map((d) => d.data()?['coverStyle'] as String?);
  }

  Future<void> updateCoverStyle(String uid, String style) async {
    await _doc(uid).update({'coverStyle': style});
  }

  // only the editable fields are sent - verified can't be changed by the artisan
  Future<void> updateProfile(ArtisanProfileModel profile) async {
    await _doc(profile.artisanUid).update({
      'displayName': profile.displayName,
      'craftType': profile.craftType,
      'about': profile.about,
      'location': profile.location,
      'updatedAt': Timestamp.now(),
    });

    await _syncArtisanName(profile.artisanUid, profile.displayName);
  }

  // The artisan name is copied into a few other documents (account, products,
  // support grants, pending invites). PDATE NAME CHANGES
  Future<void> _syncArtisanName(String uid, String name) async {
    final batch = _db.batch();
    final now = Timestamp.now();

    batch.update(_db.collection(FirestoreCollections.users).doc(uid),
        {'displayName': name, 'updatedAt': now});

    final products = await _db
        .collection(FirestoreCollections.products)
        .where('artisanId', isEqualTo: uid)
        .get();
    for (final d in products.docs) {
      batch.update(d.reference, {'artisanName': name});
    }

    final grants = await _db
        .collection(FirestoreCollections.supportGrants)
        .where('artisanId', isEqualTo: uid)
        .get();
    for (final d in grants.docs) {
      batch.update(d.reference, {'artisanName': name, 'updatedAt': now});
    }

    final invites = await _db
        .collection(FirestoreCollections.supportInvites)
        .where('artisanId', isEqualTo: uid)
        .where('status', isEqualTo: 'pending')
        .get();
    for (final d in invites.docs) {
      batch.update(d.reference, {'artisanName': name});
    }

    await batch.commit();
  }
}
