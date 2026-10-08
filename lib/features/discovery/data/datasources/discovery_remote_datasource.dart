import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/services/firebase/firestore_service.dart';
import '../../../../core/shared_models/product_model.dart';
import '../../../../core/shared_models/user_model.dart';

/// Assigned to: JAYAWARDANA V. K. A.
/// Branch: feature/buyer-discovery
class DiscoveryRemoteDataSource {
  final FirestoreService _firestoreService;

  DiscoveryRemoteDataSource({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

  /// Fetch all active products
  Stream<List<ProductModel>> getFeaturedProductsStream() {
    return _firestoreService
        .streamCollection(
          collection: FirestoreCollections.products,
          queryBuilder: (q) => q.where('isAvailable', isEqualTo: true).limit(20),
        )
        .map((snapshot) =>
            snapshot.docs.map((doc) => ProductModel.fromMap(doc.data(), doc.id)).toList());
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
        .get();

    return snapshot.docs
        .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
        .where((product) {
          final matchesQuery = query == null ||
              query.isEmpty ||
              product.title.toLowerCase().contains(query.toLowerCase()) ||
              product.description.toLowerCase().contains(query.toLowerCase());
          final matchesCategory =
              category == null || category.isEmpty || product.category == category;
          final matchesDistrict =
              district == null || district.isEmpty || product.district == district;
          final matchesPrice = maxPrice == null || product.priceLkr <= maxPrice;

          return matchesQuery && matchesCategory && matchesDistrict && matchesPrice;
        })
        .toList();
  }

  /// Get public artisan profile
  Future<UserModel?> getArtisanProfile(String artisanId) async {
    final doc = await _firestoreService.getDocument(
      collection: FirestoreCollections.users,
      docId: artisanId,
    );
    if (!doc.exists || doc.data() == null) return null;
    return UserModel.fromMap(doc.data()!, doc.id);
  }
}
