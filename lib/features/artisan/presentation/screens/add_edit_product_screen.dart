import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/craft_categories.dart';
import '../../../../core/shared_models/product_model.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../account/presentation/state/auth_provider.dart';
import '../state/product_crud_provider.dart';
import '../widgets/craft_image_picker_widget.dart';
import '../widgets/product_success_dialog.dart';

/// Assigned to: KUMARI R. P. G. D.
/// Branch: feature/artisan-management
class AddEditProductScreen extends StatefulWidget {
  final String artisanId;
  final ProductModel? productToEdit;

  const AddEditProductScreen({
    super.key,
    required this.artisanId,
    this.productToEdit,
  });

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late TextEditingController _districtController;
  late TextEditingController _materialsController;
  String _selectedCategoryKey = 'pottery';
  List<String> _imageUrls = [];

  final List<String> _districts = [
    'Kandy',
    'Colombo',
    'Galle',
    'Matara',
    'Kurunegala',
    'Kegalle',
    'Ratnapura',
    'Jaffna',
    'Batticaloa',
    'Anuradhapura',
    'Polonnaruwa',
    'Kalutara',
    'Gampaha',
    'Badulla',
    'Hambantota',
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.productToEdit;
    _titleController = TextEditingController(text: p?.title ?? '');
    _descController = TextEditingController(text: p?.description ?? '');
    _priceController = TextEditingController(
      text: p != null ? (p.priceLkr % 1 == 0 ? p.priceLkr.toInt().toString() : p.priceLkr.toString()) : '',
    );
    _stockController = TextEditingController(text: p != null ? '${p.stockQuantity}' : '5');
    _districtController = TextEditingController(text: p?.district ?? 'Kandy');
    _materialsController = TextEditingController(text: p?.materials ?? '');
    _selectedCategoryKey = p?.category ?? 'pottery';
    _imageUrls = p != null ? List<String>.from(p.imageUrls) : [];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _districtController.dispose();
    _materialsController.dispose();
    super.dispose();
  }

  void _submitForm(ProductCrudProvider provider) async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final effectiveArtisanId = widget.artisanId.isNotEmpty && widget.artisanId != 'sample_artisan_id'
        ? widget.artisanId
        : (auth.actingArtisanId ?? auth.currentUser?.uid ?? '');
    final isEditing = widget.productToEdit != null;

    // Shop name for buyers comes from the artisan profile, not from whoever is
    // signed in (a supporter adds products under the artisan's name).
    var artisanName = widget.productToEdit?.artisanName ?? '';
    if (artisanName.isEmpty) {
      artisanName = await provider.artisanDisplayName(effectiveArtisanId) ??
          auth.activeGrant?.artisanName ??
          auth.currentUser?.displayName ??
          '';
    }
    if (!mounted) return;

    final title = _titleController.text.trim();
    final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
    final stock = int.tryParse(_stockController.text.trim()) ?? 0;

    final product = ProductModel(
      id: widget.productToEdit?.id ?? '',
      artisanId: effectiveArtisanId,
      artisanName: artisanName,
      title: title,
      description: _descController.text.trim(),
      priceLkr: price,
      category: _selectedCategoryKey,
      materials: _materialsController.text.trim(),
      imageUrls: _imageUrls,
      stockQuantity: stock,
      district: _districtController.text.trim(),
      isAvailable: widget.productToEdit?.isAvailable ?? true,
      updatedBy: auth.currentUser?.uid,
      createdAt: widget.productToEdit?.createdAt,
      updatedAt: DateTime.now(),
    );

    final success = await provider.saveProduct(product, isEditing: isEditing);
    if (!mounted) return;
    if (success) {
      await ProductSuccessDialog.show(
        context,
        isEditing: isEditing,
        productTitle: title,
        onDismiss: () {
          Navigator.pop(context, product);
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Failed to publish craft listing.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.productToEdit != null;

    return ChangeNotifierProvider(
      create: (_) => ProductCrudProvider(),
      child: Consumer<ProductCrudProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            appBar: CustomAppBar(
              title: isEditing ? 'Edit Craft Creation' : 'Publish New Craft',
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                children: [
                  // Photo picker widget
                  CraftImagePickerWidget(
                    imageUrls: _imageUrls,
                    onImageAdded: (url) {
                      setState(() => _imageUrls.add(url));
                    },
                    onImageRemoved: (idx) {
                      setState(() => _imageUrls.removeAt(idx));
                    },
                  ),
                  const SizedBox(height: 20),

                  // Title field
                  CustomTextField(
                    label: 'Product Title',
                    hint: 'e.g. Handcrafted Clay Water Pitcher',
                    controller: _titleController,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Product title is required' : null,
                  ),
                  const SizedBox(height: 16),

                  // Category dropdown using CraftCategories.all
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Craft Category',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedCategoryKey,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        items: CraftCategories.all
                            .map((c) => DropdownMenuItem(
                                  value: c.key,
                                  child: Text(c.label),
                                ))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedCategoryKey = val);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Price and Stock row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomTextField(
                          label: 'Price (LKR)',
                          hint: '2500',
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          controller: _priceController,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Price required';
                            final parsed = double.tryParse(v.trim());
                            if (parsed == null || parsed <= 0) return 'Valid price';
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          label: 'Stock Quantity',
                          hint: '5',
                          keyboardType: TextInputType.number,
                          controller: _stockController,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Stock required';
                            final parsed = int.tryParse(v.trim());
                            if (parsed == null || parsed < 0) return 'Valid stock';
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Materials
                  CustomTextField(
                    label: 'Materials Used',
                    hint: 'e.g. Terracotta clay, natural river silt, organic glaze',
                    controller: _materialsController,
                  ),
                  const SizedBox(height: 16),

                  // District of Origin
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'District of Origin',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 6),
                      Autocomplete<String>(
                        initialValue: TextEditingValue(text: _districtController.text),
                        optionsBuilder: (textEditingValue) {
                          if (textEditingValue.text.isEmpty) return _districts;
                          return _districts.where(
                            (d) => d.toLowerCase().contains(textEditingValue.text.toLowerCase()),
                          );
                        },
                        onSelected: (selection) {
                          _districtController.text = selection;
                        },
                        fieldViewBuilder: (context, fieldTextEditingController, focusNode, onFieldSubmitted) {
                          fieldTextEditingController.addListener(() {
                            _districtController.text = fieldTextEditingController.text;
                          });
                          return TextFormField(
                            controller: fieldTextEditingController,
                            focusNode: focusNode,
                            decoration: const InputDecoration(
                              hintText: 'e.g. Kandy, Kegalle, Galle',
                              prefixIcon: Icon(Icons.location_on_outlined, color: AppColors.primary, size: 20),
                            ),
                            validator: (v) => (v == null || v.trim().isEmpty) ? 'District is required' : null,
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Description & Heritage Story
                  CustomTextField(
                    label: 'Heritage Story & Craft Description',
                    hint: 'Describe the traditional techniques, artisan heritage, inspiration, and care instructions...',
                    maxLines: 4,
                    controller: _descController,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Description is required';
                      if (v.trim().length < 10) return 'Please provide at least 10 characters';
                      return null;
                    },
                  ),

                  if (provider.errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        provider.errorMessage!,
                        style: const TextStyle(color: AppColors.error, fontSize: 13),
                      ),
                    ),
                  ],

                  const SizedBox(height: 28),

                  // Submit Button
                  CustomButton(
                    text: isEditing ? 'Save Changes' : 'Publish Craft Listing',
                    isLoading: provider.isSaving,
                    onPressed: () => _submitForm(provider),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
