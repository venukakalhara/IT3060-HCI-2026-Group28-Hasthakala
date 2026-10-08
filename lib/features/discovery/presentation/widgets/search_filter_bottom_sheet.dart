import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../state/search_filter_provider.dart';

class SearchFilterBottomSheet extends StatelessWidget {
  final SearchFilterProvider provider;

  const SearchFilterBottomSheet({Key? key, required this.provider}) : super(key: key);

  static const List<String> categories = [
    'Pottery',
    'Batik',
    'Wood Carving',
    'Brassware',
    'Traditional Masks',
    'Cane & Bamboo',
  ];

  static const List<String> districts = [
    'Kandy',
    'Galle',
    'Matara',
    'Kalutara',
    'Kegalle',
    'Ambalangoda',
    'Batticaloa',
    'Jaffna',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter Handicrafts',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    provider.clearFilters();
                    Navigator.pop(context);
                  },
                  child: const Text('Reset', style: TextStyle(color: AppColors.error)),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 12),
            const Text('Craft Category', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categories.map((cat) {
                final isSelected = provider.selectedCategory == cat;
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary),
                  onSelected: (selected) => provider.setCategory(selected ? cat : null),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text('Artisan Origin / District', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: districts.map((district) {
                final isSelected = provider.selectedDistrict == district;
                return ChoiceChip(
                  label: Text(district),
                  selected: isSelected,
                  selectedColor: AppColors.secondary,
                  labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary),
                  onSelected: (selected) => provider.setDistrict(selected ? district : null),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Apply Filters',
              onPressed: () {
                provider.performSearch();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
