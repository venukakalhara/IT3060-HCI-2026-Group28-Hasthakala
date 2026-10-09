import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/shared_models/artisan_profile_model.dart';
import '../../../../core/shared_models/support_models.dart';
import '../../../../core/shared_models/user_model.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/context_remote_datasource.dart';

// Where the app is in the sign-in process.
enum AuthStatus { checking, signedOut, signedIn }

// buyer, artisan or supporting someone
enum AppContextType { buyer, artisan, supporter }

// Sign-in state used across the app. Useful bits for other screens:
//   auth.currentUser        -> the signed-in person (always themselves)
//   auth.actingArtisanId    -> whose shop I11/I12/I09 should load
//                              (own uid for an artisan, the supported
//                              artisan's uid for a supporter)
//   auth.canManageProducts / canManageOrders / canRespondToCustomers
//                           -> hide/disable actions in the UI. The real
//                              protection is in firestore.rules.
class AuthProvider extends ChangeNotifier {
  final AuthRemoteDataSource _authDataSource;
  final ContextRemoteDataSource _contextDataSource;
  StreamSubscription<String?>? _authSubscription;
  StreamSubscription<SupportGrantModel?>? _grantSubscription;

  AuthProvider({
    AuthRemoteDataSource? authDataSource,
    ContextRemoteDataSource? contextDataSource,
  })  : _authDataSource = authDataSource ?? AuthRemoteDataSource(),
        _contextDataSource = contextDataSource ?? ContextRemoteDataSource() {
    // Restores the session on app start and reacts to sign-in / sign-out.
    _authSubscription = _authDataSource.uidChanges.listen(_onAuthChanged);
  }

  AuthStatus _status = AuthStatus.checking;
  UserModel? _currentUser;
  bool _hasArtisanProfile = false;
  List<SupportGrantModel> _supportGrants = [];
  AppContextType? _activeContext;
  SupportGrantModel? _activeGrant;
  bool _isLoading = false;
  bool _isRegistering = false;
  String? _errorMessage;
  bool _supportAccessLost = false;
  bool _justCreatedArtisanProfile = false;
  bool _needsPurpose = false;
  bool _justRegistered = false;
  AccountPurpose? _purposeJustChosen;
  String? _lostArtisanName;

  // ---------- Getters used across the app ----------
  AuthStatus get status => _status;
  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get hasArtisanProfile => _hasArtisanProfile;

  // set when the artisan revokes access during a supporter session
  bool get supportAccessLost => _supportAccessLost;
  bool get justCreatedArtisanProfile => _justCreatedArtisanProfile;

  // signed in but no users/{uid} yet -> "How will you start using HASTHAKALA?"
  bool get needsPurpose => _needsPurpose;
  bool get justRegistered => _justRegistered;
  AccountPurpose? get purposeJustChosen => _purposeJustChosen;
  String? get lostArtisanName => _lostArtisanName;
  List<SupportGrantModel> get supportGrants => List.unmodifiable(_supportGrants);
  AppContextType? get activeContext => _activeContext;
  SupportGrantModel? get activeGrant => _activeGrant;

  bool get isBuyerContext => _activeContext == AppContextType.buyer;
  bool get isArtisanContext => _activeContext == AppContextType.artisan;
  bool get isSupporterContext => _activeContext == AppContextType.supporter;

  // Chose "Sell my crafts" but has not completed the artisan profile yet.
  bool get needsArtisanSetup =>
      (_currentUser?.startedAsSeller ?? false) && !_hasArtisanProfile;

  // Number of contexts: buyer always + artisan + each active support grant.
  int get availableContextCount =>
      1 + (_hasArtisanProfile ? 1 : 0) + _supportGrants.length;

  // "Continue as" is shown only when there is more than one context.
  bool get needsContextChoice =>
      _status == AuthStatus.signedIn &&
      !needsArtisanSetup &&
      !_supportAccessLost &&
      !_justCreatedArtisanProfile &&
      !_needsPurpose &&
      _purposeJustChosen == null &&
      _activeContext == null &&
      availableContextCount > 1;

  // The artisan whose business I11 / I12 / I09 should show.
  String? get actingArtisanId {
    if (isArtisanContext) return _currentUser?.uid;
    if (isSupporterContext) return _activeGrant?.artisanId;
    return null;
  }

  bool get canManageProducts =>
      isArtisanContext || (isSupporterContext && (_activeGrant?.scopes.products ?? false));
  bool get canManageOrders =>
      isArtisanContext || (isSupporterContext && (_activeGrant?.scopes.orders ?? false));
  bool get canRespondToCustomers =>
      isArtisanContext || (isSupporterContext && (_activeGrant?.scopes.communication ?? false));

  // ---------- Session handling ----------
  Future<void> _onAuthChanged(String? uid) async {
    if (uid == null) {
      _resetSession();
      _status = AuthStatus.signedOut;
      notifyListeners();
      return;
    }
    // During registration the users/{uid} document is written just after the
    // Auth account is created; register loads the session itself.
    if (_isRegistering) return;
    await _loadSession(uid);
  }

  Future<void> _loadSession(String uid) async {
    _status = AuthStatus.checking;
    notifyListeners();
    try {
      final user = await _authDataSource.fetchUser(uid);
      if (user == null) {
        // account exists but sign up wasn't finished (no Shop/Sell choice yet)
        _currentUser = null;
        _needsPurpose = true;
        _status = AuthStatus.signedIn;
        notifyListeners();
        return;
      }
      _needsPurpose = false;
      _currentUser = user;
      _hasArtisanProfile = await _contextDataSource.hasArtisanProfile(uid);
      try {
        _supportGrants = await _contextDataSource.activeGrantsFor(uid);
      } catch (_) {
        _supportGrants = []; // not fatal: user simply has no support context
      }
      _activeContext = null;
      _activeGrant = null;
      if (!needsArtisanSetup && availableContextCount == 1) {
        _activeContext = AppContextType.buyer;
      }
      _status = AuthStatus.signedIn;
    } catch (_) {
      _errorMessage = 'We could not load your account. Check your connection and try again.';
      _resetSession();
      _status = AuthStatus.signedOut;
    }
    notifyListeners();
  }

  void _resetSession() {
    _grantSubscription?.cancel();
    _grantSubscription = null;
    _supportAccessLost = false;
    _lostArtisanName = null;
    _needsPurpose = false;
    _justRegistered = false;
    _purposeJustChosen = null;
    _currentUser = null;
    _hasArtisanProfile = false;
    _supportGrants = [];
    _activeContext = null;
    _activeGrant = null;
  }

  // ---------- Actions ----------
  // Google sign in. A new Google user has no users/{uid} yet, so the auth
  // listener sends them to "How will you start" like a new email account.
  Future<bool> loginWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      return await _authDataSource.loginWithGoogle();
    } on AuthException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (_) {
      _errorMessage = 'Google sign in failed. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _authDataSource.login(email, password);
      return true; // the auth listener loads the session and routes the user
    } on AuthException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (_) {
      _errorMessage = 'Something went wrong. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create Account: makes the Firebase Auth account only.
  // The users/{uid} document is written after "How will you start" (choosePurpose).
  Future<bool> createAccount({
    required String email,
    required String password,
    required String displayName,
  }) async {
    _isLoading = true;
    _isRegistering = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final uid = await _authDataSource.createAccount(
        email: email,
        password: password,
        displayName: displayName,
      );
      _isRegistering = false;
      _justRegistered = true;
      await _loadSession(uid);
      return true;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (_) {
      _errorMessage = 'We could not create your account. Please try again.';
      return false;
    } finally {
      _isRegistering = false;
      _isLoading = false;
      notifyListeners();
    }
  }

  // Continue on "Account Created!"
  void continueAfterAccountCreated() {
    _justRegistered = false;
    notifyListeners();
  }

  // "How will you start using HASTHAKALA?" - writes users/{uid}
  Future<bool> choosePurpose(AccountPurpose purpose) async {
    final account = _authDataSource.authAccount;
    if (account == null) return false;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _authDataSource.createUserDocument(
        uid: account.uid,
        email: account.email,
        displayName: account.name,
        primaryPurpose: purpose,
      );
      _needsPurpose = false;
      _purposeJustChosen = purpose;
      await _loadSession(account.uid);
      return true;
    } catch (_) {
      _errorMessage = 'We could not save your choice. Check your connection and try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Continue on "You're all set!" / "Your artisan setup has started!"
  void finishPurposeConfirmation() {
    _purposeJustChosen = null;
    notifyListeners();
  }

  Future<bool> sendPasswordReset(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _authDataSource.sendPasswordReset(email);
      return true;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (_) {
      _errorMessage = 'We could not send the reset link. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // "Continue as" choice.
  void selectContext(AppContextType type, {SupportGrantModel? grant}) {
    _grantSubscription?.cancel();
    _grantSubscription = null;
    _activeContext = type;
    _activeGrant = type == AppContextType.supporter ? grant : null;
    if (_activeGrant != null) {
      _grantSubscription =
          _contextDataSource.watchGrant(_activeGrant!.id).listen(_onGrantChanged);
    }
    notifyListeners();
  }

  // called whenever the active grant document changes
  void _onGrantChanged(SupportGrantModel? grant) {
    if (!isSupporterContext) return;
    if (grant == null || !grant.isActive) {
      _lostArtisanName = _activeGrant?.artisanName;
      _supportAccessLost = true;
      _grantSubscription?.cancel();
      _grantSubscription = null;
      _activeContext = null;
      _activeGrant = null;
    } else {
      _activeGrant = grant;
    }
    notifyListeners();
  }

  Future<void> acknowledgeSupportLoss() async {
    _supportAccessLost = false;
    _lostArtisanName = null;
    await refreshSession();
  }

  // re-read only users/{uid} (e.g. after the name changed) without
  // leaving the current context
  Future<void> reloadCurrentUser() async {
    final uid = _currentUser?.uid;
    if (uid == null) return;
    try {
      final user = await _authDataSource.fetchUser(uid);
      if (user != null) {
        _currentUser = user;
        notifyListeners();
      }
    } catch (_) {
      // keep the old copy; it refreshes on next sign in
    }
  }

  // reload user + contexts, e.g. after accepting an invite
  Future<void> refreshSession() async {
    final uid = _currentUser?.uid;
    if (uid == null) return;
    _grantSubscription?.cancel();
    _grantSubscription = null;
    await _loadSession(uid);
  }

  // Go back to the "Continue as" screen (when more than one context exists).
  void switchContext() {
    if (availableContextCount < 2) return;
    _grantSubscription?.cancel();
    _grantSubscription = null;
    _activeContext = null;
    _activeGrant = null;
    notifyListeners();
  }

  // First-time artisan setup: create artisanProfiles/{uid}, then continue
  // in the artisan context.
  Future<bool> completeArtisanSetup(ArtisanProfileModel profile) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _contextDataSource.createArtisanProfile(profile);
      _hasArtisanProfile = true;
      _justCreatedArtisanProfile = true; // show "Artisan profile created!" first
      return true;
    } catch (_) {
      _errorMessage = 'Your profile could not be saved. Check your connection and try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Continue on the "Artisan profile created!" screen
  void finishArtisanSetup() {
    _justCreatedArtisanProfile = false;
    _activeContext = AppContextType.artisan;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> logout() async {
    await _authDataSource.logout(); // the auth listener resets the session
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _grantSubscription?.cancel();
    super.dispose();
  }
}
