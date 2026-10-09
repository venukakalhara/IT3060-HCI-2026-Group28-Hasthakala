import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/shared_models/product_model.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../account/presentation/state/auth_provider.dart';
import '../state/product_crud_provider.dart';
import '../widgets/craft_image_picker_widget.dart';

/// Assigned to: KUMARI R. P. G. D.
/// Branch: feature/artisan-management
class AddEditProductScreen extends StatefulWidget {
  final String artisanId;
  final ProductModel? productToEdit;

  const AddEditProductScreen({
    Key? key,
    required this.artisanId,
    this.productToEdit,
  }) : super(key: key);

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
  String _selectedCategory = 'Pottery';
  List<String> _imageUrls = [];

  final List<String> _categories = [
    'Pottery',
    'Batik',
    'Wood Carving',
    'Brassware',
    'Traditional Masks',
    'Cane & Bamboo',
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.productToEdit;
    _titleController = TextEditingController(text: p?.title ?? '');
    _descController = TextEditingController(text: p?.description ?? '');
    _priceController =
        TextEditingController(text: p != null ? '${p.priceLkr}' : '');
    _stockController =
        TextEditingController(text: p != null ? '${p.stockQuantity}' : '1');
    _districtController = TextEditingController(text: p?.district ?? 'Kandy');
    _selectedCategory = p?.category ?? 'Pottery';
    _imageUrls = p?.imageUrls ?? [];
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
                padding: const EdgeInsets.all(16),
                children: [
                  CraftImagePickerWidget(
                    imageUrls: _imageUrls,
                    onPickImage: () {
                      // Add image picker logic (File to Firebase Storage)
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Product Title',
                    hint: 'e.g. Handcrafted Clay Water Pitcher',
                    controller: _titleController,
                    validator: (v) => v!.isEmpty ? 'Title is required' : null,
                  ),
                  const SizedBox(height: 14),
                  const Text('Category',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(12)),
                    items: _categories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedCategory = val);
                    },
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          label: 'Price (LKR)',
                          hint: '2500',
                          keyboardType: TextInputType.number,
                          controller: _priceController,
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          label: 'Stock Quantity',
                          hint: '5',
                          keyboardType: TextInputType.number,
                          controller: _stockController,
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  CustomTextField(
                    label: 'Craft District of Origin',
                    hint: 'e.g. Kegalle / Kandy',
                    controller: _districtController,
                  ),
                  const SizedBox(height: 14),
                  CustomTextField(
                    label: 'Description & Heritage Story',
                    hint:
                        'Explain the craft techniques, materials, and cultural value...',
                    maxLines: 4,
                    controller: _descController,
                    validator: (v) =>
                        v!.isEmpty ? 'Description is required' : null,
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: isEditing ? 'Update Listing' : 'Publish Listing',
                    isLoading: provider.isSaving,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final auth = context.read<AuthProvider>();
                        final artisanName = widget.productToEdit?.artisanName ??
                            auth.activeGrant?.artisanName ??
                            auth.currentUser?.displayName ??
                            'Artisan';
                        final product = ProductModel(
                          id: widget.productToEdit?.id ?? '',
                          artisanId: widget.artisanId,
                          artisanName: artisanName,
                          title: _titleController.text.trim(),
                          description: _descController.text.trim(),
                          priceLkr:
                              double.tryParse(_priceController.text) ?? 0.0,
                          category: _selectedCategory,
                          imageUrls: _imageUrls,
                          stockQuantity:
                              int.tryParse(_stockController.text) ?? 1,
                          district: _districtController.text.trim(),
                        );

                        final success = await provider.saveProduct(product,
                            isEditing: isEditing);
                        if (success && mounted) {
                          Navigator.pop(context);
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
