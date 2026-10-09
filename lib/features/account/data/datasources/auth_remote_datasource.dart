import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/services/firebase/firebase_auth_service.dart';
import '../../../../core/services/firebase/firestore_service.dart';
import '../../../../core/shared_models/user_model.dart';

// sign in / sign up data: Firebase Auth + users/{uid}
class AuthRemoteDataSource {
  final FirebaseAuthService _authService;
  final FirestoreService _firestoreService;

  AuthRemoteDataSource({
    FirebaseAuthService? authService,
    FirestoreService? firestoreService,
  })  : _authService = authService ?? FirebaseAuthService(),
        _firestoreService = firestoreService ?? FirestoreService();

  // Emits the signed-in user's uid, or null when signed out.
  // Firebase keeps the session on the device, so this restores it on restart.
  Stream<String?> get uidChanges =>
      _authService.authStateChanges.map((user) => user?.uid);

  // read users/{uid}
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

  // false when the person closes the Google account picker
  Future<bool> loginWithGoogle() async {
    final credential = await _authService.signInWithGoogle();
    return credential != null;
  }

  // step 1 of sign up: only the Firebase Auth account (Create Account screen)
  Future<String> createAccount({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final credential = await _authService.signUpWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user!;
    await user.updateDisplayName(displayName.trim());
    return user.uid;
  }

  // details of the signed-in Firebase Auth account (used before users/{uid} exists)
  ({String uid, String email, String name})? get authAccount {
    final user = _authService.currentUser;
    if (user == null) return null;
    return (uid: user.uid, email: user.email ?? '', name: user.displayName ?? '');
  }

  // step 2 of sign up: users/{uid} once they pick Shop or Sell
  Future<void> createUserDocument({
    required String uid,
    required String email,
    required String displayName,
    required AccountPurpose primaryPurpose,
  }) async {
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
  }

  Future<void> sendPasswordReset(String email) =>
      _authService.sendPasswordResetEmail(email);

  Future<void> logout() => _authService.signOut();
}
