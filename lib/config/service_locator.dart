import '../core/services/firebase/firebase_auth_service.dart';
import '../core/services/firebase/firestore_service.dart';
import '../core/services/firebase/storage_service.dart';
import '../core/services/local_storage_service.dart';

/// Lightweight Service Locator pattern
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  late final FirebaseAuthService authService;
  late final FirestoreService firestoreService;
  late final StorageService storageService;
  late final LocalStorageService localStorageService;

  Future<void> setup() async {
    authService = FirebaseAuthService();
    firestoreService = FirestoreService();
    storageService = StorageService();
    localStorageService = LocalStorageService();
  }
}

final sl = ServiceLocator();
