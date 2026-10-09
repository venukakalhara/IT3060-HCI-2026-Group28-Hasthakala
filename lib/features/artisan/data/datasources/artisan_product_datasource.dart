import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/services/firebase/firestore_service.dart';
import '../../../../core/shared_models/product_model.dart';
import '../../../../core/utils/firestore_converters.dart';

/// Assigned to: KUMARI R. P. G. D.
/// Branch: feature/artisan-management
class ArtisanProductDataSource {
  final FirestoreService _firestoreService;

  ArtisanProductDataSource({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

  Stream<List<ProductModel>> getArtisanProducts(String artisanId) {
    return _firestoreService
        .streamCollection(
          collection: FirestoreCollections.products,
          queryBuilder: (q) => q.where('artisanId', isEqualTo: artisanId),
        )
        .map((snapshot) =>
            snapshot.docs.map((doc) => ProductModel.fromMap(doc.data(), doc.id)).toList());
  }

  // Shop name buyers see on a new listing, taken from the artisan profile
  // (not the signed-in account, which may be a supporter).
  Future<String?> getArtisanDisplayName(String artisanId) async {
    final doc = await _firestoreService.getDocument(
      collection: FirestoreCollections.artisanProfiles,
      docId: artisanId,
    );
    final name = doc.data()?['displayName'];
    if (name is String && name.trim().isNotEmpty) return name.trim();
    return null;
  }

  Future<String> createProduct(ProductModel product) async {
    final docRef = _firestoreService.instance.collection(FirestoreCollections.products).doc();
    final newProduct = ProductModel(
      id: docRef.id,
      artisanId: product.artisanId,
      artisanName: product.artisanName,
      title: product.title,
      description: product.description,
      priceLkr: product.priceLkr,
      category: product.category,
      materials: product.materials,
      imageUrls: product.imageUrls,
      stockQuantity: product.stockQuantity,
      district: product.district,
      isAvailable: product.isAvailable,
      updatedBy: product.updatedBy,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await docRef.set(newProduct.toMap());
    return docRef.id;
  }

  Future<void> updateProduct(ProductModel product) async {
    final updateData = product.toMap();
    updateData['updatedAt'] = FirestoreConverters.toTimestamp(DateTime.now());
    await _firestoreService.setDocument(
      collection: FirestoreCollections.products,
      docId: product.id,
      data: updateData,
      merge: true,
    );
  }

  Future<void> toggleAvailability(String productId, bool isAvailable, {String? updatedBy}) async {
    await _firestoreService.setDocument(
      collection: FirestoreCollections.products,
      docId: productId,
      data: {
        'isAvailable': isAvailable,
        'updatedAt': FirestoreConverters.toTimestamp(DateTime.now()),
        if (updatedBy != null) 'updatedBy': updatedBy,
      },
      merge: true,
    );
  }

  Future<void> deleteProduct(String productId) async {
    await _firestoreService.deleteDocument(
      collection: FirestoreCollections.products,
      docId: productId,
    );
  }
}
