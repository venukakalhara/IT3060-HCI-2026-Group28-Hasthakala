import '../utils/firestore_converters.dart';

// products/{productId} - I11 writes,
// I02-I04 read. Some Dart names differ from the stored field names:
//   id -> productId, priceLkr -> price, district -> originDistrict.
class ProductModel {
  final String id;
  final String artisanId;
  final String artisanName;
  final String title;
  final String description;
  final double priceLkr;
  final String category;
  final String materials;
  final List<String> imageUrls;
  final int stockQuantity;
  final String district;
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? updatedBy;

  // worked out from reviews when shown, not stored on the product
  final double rating;
  final int reviewCount;

  ProductModel({
    required this.id,
    required this.artisanId,
    required this.artisanName,
    required this.title,
    required this.description,
    required this.priceLkr,
    required this.category,
    required this.imageUrls,
    this.materials = '',
    this.stockQuantity = 1,
    required this.district,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isAvailable = true,
    this.updatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'productId': id,
      'artisanId': artisanId,
      'artisanName': artisanName,
      'title': title,
      'description': description,
      'category': category,
      'materials': materials,
      'originDistrict': district,
      'price': priceLkr,
      'stockQuantity': stockQuantity,
      'isAvailable': isAvailable,
      'imageUrls': imageUrls,
      'createdAt': FirestoreConverters.toTimestamp(createdAt),
      'updatedAt': FirestoreConverters.toTimestamp(updatedAt),
      'updatedBy': updatedBy,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map, String docId) {
    return ProductModel(
      id: docId,
      artisanId: map['artisanId'] ?? '',
      artisanName: map['artisanName'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      priceLkr: (map['price'] as num?)?.toDouble() ?? 0.0,
      category: map['category'] ?? 'other',
      materials: map['materials'] ?? '',
      imageUrls: List<String>.from(map['imageUrls'] ?? const []),
      stockQuantity: (map['stockQuantity'] as num?)?.toInt() ?? 0,
      district: map['originDistrict'] ?? '',
      isAvailable: map['isAvailable'] ?? true,
      updatedBy: map['updatedBy'],
      createdAt: FirestoreConverters.toDateTime(map['createdAt']),
      updatedAt: FirestoreConverters.toDateTime(map['updatedAt']),
    );
  }
}
