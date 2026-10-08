import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/services/firebase/firebase_auth_service.dart';
import '../../../../core/services/firebase/firestore_service.dart';
import '../../../../core/shared_models/user_model.dart';

/// I01 Entry/Auth data access (Member 4).
/// Identity comes from Firebase Authentication; the account document is
/// users/{uid} (see docs/FIREBASE_SCHEMA.md).
class AuthRemoteDataSource {
  final FirebaseAuthService _authService;
  final FirestoreService _firestoreService;

  AuthRemoteDataSource({
    FirebaseAuthService? authService,
    FirestoreService? firestoreService,
  })  : _authService = authService ?? FirebaseAuthService(),
        _firestoreService = firestoreService ?? FirestoreService();

  /// Emits the signed-in user's uid, or null when signed out.
  /// Firebase keeps the session on the device, so this restores it on restart.
  Stream<String?> get uidChanges =>
      _authService.authStateChanges.map((user) => user?.uid);

  /// READ users/{uid}
  Future<UserModel?> fetchUser(String uid) async {
    final doc = await _firestoreService.getDocument(
      collection: FirestoreCollections.users,
      docId: uid,
    );
    if (!doc.exists || doc.data() == null) return null;
    return UserModel.fromMap(doc.data()!, doc.id);
  }

  Future<void> login(String email, String password) async {
    await _authService.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// CREATE Firebase Auth account + users/{uid}
  Future<UserModel> register({
    required String email,
    required String password,
    required String displayName,
    required AccountPurpose primaryPurpose,
  }) async {
    final credential = await _authService.signUpWithEmailAndPassword(
      email: email,
      password: password,
    );
    final uid = credential.user!.uid;

    final newUser = UserModel(
      uid: uid,
      email: email.trim(),
      displayName: displayName.trim(),
      primaryPurpose: primaryPurpose,
    );

    await _firestoreService.setDocument(
      collection: FirestoreCollections.users,
      docId: uid,
      data: newUser.toMap(),
      merge: false,
    );

    return newUser;
  }

  Future<void> sendPasswordReset(String email) =>
      _authService.sendPasswordResetEmail(email);

  Future<void> logout() => _authService.signOut();
}
