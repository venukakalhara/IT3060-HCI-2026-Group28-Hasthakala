import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../errors/exceptions.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth;
  final GoogleSignIn _google;

  FirebaseAuthService({FirebaseAuth? auth, GoogleSignIn? google})
      : _auth = auth ?? FirebaseAuth.instance,
        _google = google ?? GoogleSignIn();

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

  // Google account picker > Firebase sign in. null when the picker is closed.
  // Needs the Google provider on in Firebase and this laptop's SHA-1 added.
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final googleUser = await _google.signIn();
      if (googleUser == null) return null;
      final tokens = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: tokens.idToken,
        accessToken: tokens.accessToken,
      );
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw AuthException(friendlyMessage(e.code));
    } on PlatformException catch (e) {
      throw AuthException(e.code == 'network_error'
          ? friendlyMessage('network-request-failed')
          : 'Google sign in failed. Please try again.');
    } catch (_) {
      throw const AuthException('Google sign in failed. Please try again.');
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw AuthException(friendlyMessage(e.code));
    }
  }

  // turns Firebase error codes into messages people can act on
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
      case 'account-exists-with-different-credential':
        return 'This email already has an account. Sign in with your email and password.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  Future<void> signOut() async {
    // also forget the Google account, so the picker shows next time
    try {
      await _google.signOut();
    } catch (_) {}
    await _auth.signOut();
  }
}
