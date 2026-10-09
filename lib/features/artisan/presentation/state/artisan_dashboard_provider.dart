import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/shared_models/product_model.dart';
import '../../data/datasources/artisan_product_datasource.dart';

/// Assigned to: KUMARI R. P. G. D.
/// Branch: feature/artisan-management
class ArtisanDashboardProvider extends ChangeNotifier {
  final ArtisanProductDataSource _productDataSource;
  StreamSubscription<List<ProductModel>>? _productsSubscription;

  ArtisanDashboardProvider({ArtisanProductDataSource? productDataSource})
      : _productDataSource = productDataSource ?? ArtisanProductDataSource();

  List<ProductModel> _myProducts = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  String _stockFilter = 'all'; // all, in_stock, low_stock, out_of_stock
  String _categoryFilter = 'all';

  List<ProductModel> get myProducts => List.unmodifiable(_myProducts);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String get stockFilter => _stockFilter;
  String get categoryFilter => _categoryFilter;

  int get totalListings => _myProducts.length;
  int get activeListings => _myProducts.where((p) => p.isAvailable && p.stockQuantity > 0).length;
  int get outOfStockCount => _myProducts.where((p) => p.stockQuantity <= 0 || !p.isAvailable).length;
  int get lowStockCount => _myProducts.where((p) => p.stockQuantity > 0 && p.stockQuantity <= 3).length;
  int get inStockCount => _myProducts.where((p) => p.stockQuantity > 3 && p.isAvailable).length;

  List<ProductModel> get filteredProducts {
    return _myProducts.where((product) {
      // Category filter
      if (_categoryFilter != 'all' && product.category != _categoryFilter) {
        return false;
      }
      // Stock filter
      if (_stockFilter == 'in_stock' && (product.stockQuantity <= 3 || !product.isAvailable)) {
        return false;
      } else if (_stockFilter == 'low_stock' && (product.stockQuantity <= 0 || product.stockQuantity > 3)) {
        return false;
      } else if (_stockFilter == 'out_of_stock' && product.stockQuantity > 0 && product.isAvailable) {
        return false;
      }
      // Search filter
      if (_searchQuery.trim().isNotEmpty) {
        final q = _searchQuery.trim().toLowerCase();
        final matchesTitle = product.title.toLowerCase().contains(q);
        final matchesCategory = product.category.toLowerCase().contains(q);
        final matchesDistrict = product.district.toLowerCase().contains(q);
        return matchesTitle || matchesCategory || matchesDistrict;
      }
      return true;
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setStockFilter(String filter) {
    _stockFilter = filter;
    notifyListeners();
  }

  void setCategoryFilter(String category) {
    _categoryFilter = category;
    notifyListeners();
  }

  void listenToArtisanProducts(String artisanId) {
    _productsSubscription?.cancel();
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    _productsSubscription = _productDataSource.getArtisanProducts(artisanId).listen(
      (items) {
        items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        _myProducts = items;
        _isLoading = false;
        notifyListeners();
      },
      onError: (e) {
        _isLoading = false;
        _errorMessage = 'Could not load products: $e';
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _productsSubscription?.cancel();
    super.dispose();
  }
}
