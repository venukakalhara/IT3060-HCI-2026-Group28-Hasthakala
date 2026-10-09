import 'package:flutter/material.dart';
import '../../../../core/shared_models/product_model.dart';
import '../../data/datasources/artisan_product_datasource.dart';

/// Assigned to: KUMARI R. P. G. D.
/// Branch: feature/artisan-management
class ProductCrudProvider extends ChangeNotifier {
  final ArtisanProductDataSource _dataSource;

  ProductCrudProvider({ArtisanProductDataSource? dataSource})
      : _dataSource = dataSource ?? ArtisanProductDataSource();

  bool _isSaving = false;
  bool _isDeleting = false;
  String? _errorMessage;

  bool get isSaving => _isSaving;
  bool get isDeleting => _isDeleting;
  String? get errorMessage => _errorMessage;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<String?> artisanDisplayName(String artisanId) async {
    try {
      return await _dataSource.getArtisanDisplayName(artisanId);
    } catch (_) {
      return null;
    }
  }

  Future<bool> saveProduct(ProductModel product, {bool isEditing = false}) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (isEditing) {
        await _dataSource.updateProduct(product);
      } else {
        await _dataSource.createProduct(product);
      }
      _isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isSaving = false;
      _errorMessage = 'Failed to save product: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProduct(String productId) async {
    _isDeleting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _dataSource.deleteProduct(productId);
      _isDeleting = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isDeleting = false;
      _errorMessage = 'Failed to delete product: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> toggleAvailability(String productId, bool isAvailable, {String? updatedBy}) async {
    try {
      await _dataSource.toggleAvailability(productId, isAvailable, updatedBy: updatedBy);
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update availability: $e';
      notifyListeners();
      return false;
    }
  }

  @Deprecated('Use deleteProduct(productId)')
  Future<void> removeProduct(String productId) async {
    await deleteProduct(productId);
  }
}
