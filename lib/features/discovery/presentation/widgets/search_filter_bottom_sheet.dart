import '../discovery_labels.dart';
import '../../../../core/localization/tr.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/craft_categories.dart';
import '../state/search_filter_provider.dart';

class SearchFilterBottomSheet extends StatefulWidget {
  const SearchFilterBottomSheet({super.key, required this.provider});
  final SearchFilterProvider provider;
  @override
  State<SearchFilterBottomSheet> createState() =>
      _SearchFilterBottomSheetState();
}

class _SearchFilterBottomSheetState extends State<SearchFilterBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _price;
  String? _category;
  String? _district;
  static const _districts = [
    'Ampara',
    'Anuradhapura',
    'Badulla',
    'Batticaloa',
    'Colombo',
    'Galle',
    'Gampaha',
    'Hambantota',
    'Jaffna',
    'Kalutara',
    'Kandy',
    'Kegalle',
    'Kilinochchi',
    'Kurunegala',
    'Mannar',
    'Matale',
    'Matara',
    'Monaragala',
    'Mullaitivu',
    'Nuwara Eliya',
    'Polonnaruwa',
    'Puttalam',
    'Ratnapura',
    'Trincomalee',
    'Vavuniya',
    'Ambalangoda',
    'Kelaniya',
  ];
  @override
  void initState() {
    super.initState();
    _category = widget.provider.selectedCategory;
    _district = widget.provider.selectedDistrict;
    _price =
        TextEditingController(text: widget.provider.maxPrice?.toString() ?? '');
  }

  @override
  void dispose() {
    _price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
          child: Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * .85),
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
            child: SingleChildScrollView(
                child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(
                        child: Text(context.tr('discovery_filter_title'),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))),
                    TextButton(
                        onPressed: () {
                          widget.provider.clearFilters();
                          Navigator.pop(context);
                        },
                        child: Text(context.tr('discovery_reset'))),
                  ]),
                  Text(context.tr('discovery_category')),
                  const SizedBox(height: 8),
                  Wrap(
                      spacing: 8,
                      children: CraftCategories.all
                          .map((category) => ChoiceChip(
                                label: Text(discoveryCategoryLabel(
                                    context, category.key)),
                                selected: _category == category.key,
                                onSelected: (selected) => setState(() =>
                                    _category = selected ? category.key : null),
                              ))
                          .toList()),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _district,
                    isExpanded: true,
                    decoration: InputDecoration(
                        labelText: context.tr('discovery_origin')),
                    items: [
                      DropdownMenuItem<String>(
                          value: null,
                          child: Text(context.tr('discovery_any_origin'))),
                      ...{
                        ..._districts,
                        if (_district != null) _district!
                      }.map((district) => DropdownMenuItem(
                          value: district,
                          child:
                              Text(discoveryOriginLabel(context, district)))),
                    ],
                    onChanged: (value) => setState(() => _district = value),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _price,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                        labelText: context.tr('discovery_max_price'),
                        hintText: context.tr('discovery_any_price')),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return null;
                      final price = double.tryParse(value.trim());
                      return price == null || !price.isFinite || price < 0
                          ? context.tr('discovery_invalid_price')
                          : null;
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) return;
                          widget.provider.applyFilters(
                              category: _category,
                              district: _district,
                              maxPrice: double.tryParse(_price.text.trim()));
                          Navigator.pop(context);
                        },
                        child: Text(context.tr('discovery_apply')),
                      )),
                ],
              ),
            )),
          ),
        ),
      );
}
