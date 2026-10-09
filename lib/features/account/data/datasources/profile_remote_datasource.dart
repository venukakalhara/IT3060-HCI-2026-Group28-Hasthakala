import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/services/firebase/firestore_service.dart';
import '../../../../core/shared_models/user_model.dart';

// Assigned to: WANIGATHUNGA Y. J.
// Branch: feature/account-support
class ProfileRemoteDataSource {
  final FirestoreService _firestoreService;

  ProfileRemoteDataSource({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

  Future<void> updateProfile(UserModel user) async {
    await _firestoreService.setDocument(
      collection: FirestoreCollections.users,
      docId: user.uid,
      data: user.toMap(),
    );
  }

  Stream<UserModel?> streamUserProfile(String uid) {
    return _firestoreService.instance
        .collection(FirestoreCollections.users)
        .doc(uid)
        .snapshots()
        .map((doc) => doc.exists && doc.data() != null
            ? UserModel.fromMap(doc.data()!, doc.id)
            : null);
  }
}
