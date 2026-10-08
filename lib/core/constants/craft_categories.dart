/// Shared craft category list (schema S1: stored value = `key`, shown = `label`).
/// Used for products.category and artisanProfiles.craftType.
/// New categories may be ADDED; never change an existing key.
class CraftCategory {
  final String key;
  final String label;
  const CraftCategory(this.key, this.label);
}

class CraftCategories {
  static const List<CraftCategory> all = [
    CraftCategory('pottery', 'Pottery'),
    CraftCategory('batik', 'Batik'),
    CraftCategory('wood_carving', 'Wood Carving'),
    CraftCategory('masks', 'Masks'),
    CraftCategory('handloom_textiles', 'Handloom & Textiles'),
    CraftCategory('jewellery', 'Jewellery'),
    CraftCategory('brassware', 'Brassware'),
    CraftCategory('cane_bamboo', 'Cane & Bamboo'),
    CraftCategory('coconut_shell', 'Coconut Shell Craft'),
    CraftCategory('home_decor', 'Home Decor'),
    CraftCategory('other', 'Other'),
  ];

  static String labelFor(String key) => all
      .firstWhere((c) => c.key == key, orElse: () => CraftCategory(key, key))
      .label;
}
