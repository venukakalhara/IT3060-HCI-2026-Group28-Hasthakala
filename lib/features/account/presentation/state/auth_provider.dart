import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/shared_models/artisan_profile_model.dart';
import '../../../../core/shared_models/support_models.dart';
import '../../../../core/shared_models/user_model.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/context_remote_datasource.dart';

/// Where the app is in the sign-in process.
enum AuthStatus { checking, signedOut, signedIn }

/// Which "hat" the person is currently wearing (decision D1).
enum AppContextType { buyer, artisan, supporter }

/// I01 Entry/Auth state (Member 4) - shared by ALL members.
///
/// Other members should use:
///   auth.currentUser        -> the signed-in person (always themselves)
///   auth.actingArtisanId    -> whose shop I11/I12/I09 should load
///                              (own uid for an artisan, the supported
///                              artisan's uid for a supporter)
///   auth.canManageProducts / canManageOrders / canRespondToCustomers
///                           -> hide/disable actions in the UI. The real
///                              protection is in firestore.rules (NFR3).
class AuthProvider extends ChangeNotifier {
  final AuthRemoteDataSource _authDataSource;
  final ContextRemoteDataSource _contextDataSource;
  StreamSubscription<String?>? _authSubscription;

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

  // ---------- Getters used across the app ----------
  AuthStatus get status => _status;
  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get hasArtisanProfile => _hasArtisanProfile;
  List<SupportGrantModel> get supportGrants => List.unmodifiable(_supportGrants);
  AppContextType? get activeContext => _activeContext;
  SupportGrantModel? get activeGrant => _activeGrant;

  bool get isBuyerContext => _activeContext == AppContextType.buyer;
  bool get isArtisanContext => _activeContext == AppContextType.artisan;
  bool get isSupporterContext => _activeContext == AppContextType.supporter;

  /// Chose "Sell my crafts" but has not completed the artisan profile yet.
  bool get needsArtisanSetup =>
      (_currentUser?.startedAsSeller ?? false) && !_hasArtisanProfile;

  /// Number of contexts: buyer always + artisan + each active support grant.
  int get availableContextCount =>
      1 + (_hasArtisanProfile ? 1 : 0) + _supportGrants.length;

  /// "Continue as" is shown only when there is more than one context (D1).
  bool get needsContextChoice =>
      _status == AuthStatus.signedIn &&
      !needsArtisanSetup &&
      _activeContext == null &&
      availableContextCount > 1;

  /// The artisan whose business I11 / I12 / I09 should show.
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
    // Auth account is created; register() loads the session itself.
    if (_isRegistering) return;
    await _loadSession(uid);
  }

  Future<void> _loadSession(String uid) async {
    _status = AuthStatus.checking;
    notifyListeners();
    try {
      final user = await _authDataSource.fetchUser(uid);
      if (user == null) {
        _errorMessage = 'We could not find your account details. Please sign in again.';
        await _authDataSource.logout();
        return;
      }
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
    _currentUser = null;
    _hasArtisanProfile = false;
    _supportGrants = [];
    _activeContext = null;
    _activeGrant = null;
  }

  // ---------- Actions ----------
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

  Future<bool> register({
    required String email,
    required String password,
    required String displayName,
    required AccountPurpose primaryPurpose,
  }) async {
    _isLoading = true;
    _isRegistering = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final user = await _authDataSource.register(
        email: email,
        password: password,
        displayName: displayName,
        primaryPurpose: primaryPurpose,
      );
      _isRegistering = false;
      await _loadSession(user.uid);
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

  /// "Continue as" choice (I01, D1).
  void selectContext(AppContextType type, {SupportGrantModel? grant}) {
    _activeContext = type;
    _activeGrant = type == AppContextType.supporter ? grant : null;
    notifyListeners();
  }

  /// Go back to the "Continue as" screen (when more than one context exists).
  void switchContext() {
    if (availableContextCount < 2) return;
    _activeContext = null;
    _activeGrant = null;
    notifyListeners();
  }

  /// First-time artisan setup: CREATE artisanProfiles/{uid}, then continue
  /// in the artisan context.
  Future<bool> completeArtisanSetup(ArtisanProfileModel profile) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _contextDataSource.createArtisanProfile(profile);
      _hasArtisanProfile = true;
      _activeContext = AppContextType.artisan;
      return true;
    } catch (_) {
      _errorMessage = 'Your profile could not be saved. Check your connection and try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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
    super.dispose();
  }
}
