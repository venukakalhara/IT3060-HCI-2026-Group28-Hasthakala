import '../../../core/constants/craft_categories.dart';
import '../../../core/shared_models/product_model.dart';

/// Accept shared keys and labels used by older product editors.
String? discoveryCategoryKey(String? value) {
  final normalized = value?.trim().toLowerCase();
  if (normalized == null || normalized.isEmpty) return null;
  for (final category in CraftCategories.all) {
    if (normalized == category.key ||
        normalized == category.label.toLowerCase()) {
      return category.key;
    }
  }
  return const {
        'pottery & clay': 'pottery',
        'terracotta & clay': 'pottery',
        'woodcarving': 'wood_carving',
        'traditional masks': 'masks',
        'kaduru masks': 'masks',
        'batik & weave': 'batik',
        'dumbara weave': 'handloom_textiles',
        'brass casting': 'brassware',
      }[normalized] ??
      normalized;
}

List<ProductModel> filterDiscoveryProducts(
  Iterable<ProductModel> products, {
  String? query,
  String? category,
  String? district,
  double? maxPrice,
}) {
  final term = query?.trim().toLowerCase() ?? '';
  final categoryKey = discoveryCategoryKey(category);
  final origin = district?.trim().toLowerCase() ?? '';
  return products
      .where((product) =>
          product.isAvailable &&
          (term.isEmpty ||
              '${product.title} ${product.description} ${product.materials} ${product.artisanName}'
                  .toLowerCase()
                  .contains(term)) &&
          (categoryKey == null ||
              discoveryCategoryKey(product.category) == categoryKey) &&
          (origin.isEmpty || product.district.trim().toLowerCase() == origin) &&
          (maxPrice == null || product.priceLkr <= maxPrice))
      .toList();
}
