import 'package:firebase_auth/firebase_auth.dart';
import '../../errors/exceptions.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth;

  FirebaseAuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(friendlyMessage(e.code));
    } catch (e) {
      throw const AuthException('Something went wrong. Please try again.');
    }
  }

  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(friendlyMessage(e.code));
    } catch (e) {
      throw const AuthException('Something went wrong. Please try again.');
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw AuthException(friendlyMessage(e.code));
    }
  }

  /// Plain-language messages for Firebase error codes (heuristic: help users
  /// recognise, diagnose and recover from errors). Wording follows the I01 hi-fi.
  static String friendlyMessage(String code) {
    switch (code) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Email or password is incorrect. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email. Try signing in instead.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'network-request-failed':
        return 'No internet connection. Check your connection and try again.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a moment and try again.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
