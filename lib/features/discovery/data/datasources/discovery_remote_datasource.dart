import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/services/firebase/firestore_service.dart';
import '../../../../core/shared_models/product_model.dart';
import '../../../../core/shared_models/artisan_profile_model.dart';
import '../discovery_filters.dart';

/// Assigned to: JAYAWARDANA V. K. A.
/// Branch: feature/buyer-discovery
class DiscoveryRemoteDataSource {
  Future<List<ProductModel>> getSavedProducts(List<String> ids) async {
    final documents = await Future.wait(ids.map((id) => _firestoreService
            .getDocument(collection: FirestoreCollections.products, docId: id)))
        .timeout(const Duration(seconds: 10));
    return documents
        .where((doc) => doc.exists && doc.data() != null)
        .map((doc) => ProductModel.fromMap(doc.data()!, doc.id))
        .toList();
  }

  final FirestoreService _firestoreService;

  DiscoveryRemoteDataSource({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

  /// Fetch all active products
  Stream<List<ProductModel>> getFeaturedProductsStream() {
    return _firestoreService
        .streamCollection(
      collection: FirestoreCollections.products,
      queryBuilder: (q) => q.where('isAvailable', isEqualTo: true),
    )
        .map((snapshot) {
      final products = snapshot.docs
          .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      // The newest listing must always enter the featured feed immediately.
      return products.take(20).toList(growable: false);
    });
  }

  /// Search & filter products by craft category or district
  Future<List<ProductModel>> searchProducts({
    String? query,
    String? category,
    String? district,
    double? maxPrice,
  }) async {
    final snapshot = await _firestoreService.instance
        .collection(FirestoreCollections.products)
        .where('isAvailable', isEqualTo: true)
        .get()
        .timeout(const Duration(seconds: 10));

    return filterDiscoveryProducts(
      snapshot.docs.map((doc) => ProductModel.fromMap(doc.data(), doc.id)),
      query: query,
      category: category,
      district: district,
      maxPrice: maxPrice,
    );
  }

  /// Get public artisan profile
  Future<List<ArtisanProfileModel>> searchArtisans() async {
    final snapshot = await _firestoreService.instance
        .collection(FirestoreCollections.artisanProfiles)
        .get()
        .timeout(const Duration(seconds: 10));
    return snapshot.docs
        .map((doc) => ArtisanProfileModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  /// Get public artisan profile
  Future<ArtisanProfileModel?> getArtisanProfile(String artisanId) async {
    if (artisanId.isEmpty) return null;
    final doc = await _firestoreService
        .getDocument(
          collection: FirestoreCollections.artisanProfiles,
          docId: artisanId,
        )
        .timeout(const Duration(seconds: 10));

    if (!doc.exists || doc.data() == null) return null;
    return ArtisanProfileModel.fromMap(doc.data()!, doc.id);
  }

  Future<List<ProductModel>> getArtisanProducts(String artisanId) async {
    if (artisanId.isEmpty) return [];
    final snapshot = await _firestoreService.instance
        .collection(FirestoreCollections.products)
        .where('artisanId', isEqualTo: artisanId)
        .get()
        .timeout(const Duration(seconds: 10));
    return snapshot.docs
        .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
        .where((product) => product.isAvailable)
        .toList();
  }
}
