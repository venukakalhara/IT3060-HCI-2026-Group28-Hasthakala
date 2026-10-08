import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/services/firebase/firestore_service.dart';

/// Assigned to: WANIGATHUNGA Y. J.
/// Branch: feature/account-support
class FamilySupportDataSource {
  final FirestoreService _firestoreService;

  FamilySupportDataSource({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

  Future<void> delegatePermissions({
    required String elderArtisanUid,
    required String assistantEmail,
    required bool canManageOrders,
    required bool canManageListings,
    required bool canReplyMessages,
  }) async {
    await _firestoreService.addDocument(
      collection: FirestoreCollections.familyPermissions,
      data: {
        'elderArtisanUid': elderArtisanUid,
        'assistantEmail': assistantEmail,
        'canManageOrders': canManageOrders,
        'canManageListings': canManageListings,
        'canReplyMessages': canReplyMessages,
        'createdAt': DateTime.now().toIso8601String(),
      },
    );
  }
}
