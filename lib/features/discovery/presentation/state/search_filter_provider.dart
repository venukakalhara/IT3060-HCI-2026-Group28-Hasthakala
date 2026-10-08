import 'package:flutter/material.dart';
import '../../../../core/shared_models/product_model.dart';
import '../../data/datasources/discovery_remote_datasource.dart';

/// Assigned to: JAYAWARDANA V. K. A.
/// Branch: feature/buyer-discovery
class SearchFilterProvider extends ChangeNotifier {
  final DiscoveryRemoteDataSource _dataSource;

  SearchFilterProvider({DiscoveryRemoteDataSource? dataSource})
      : _dataSource = dataSource ?? DiscoveryRemoteDataSource();

  List<ProductModel> _searchResults = [];
  bool _isSearching = false;
  String? _selectedCategory;
  String? _selectedDistrict;
  double _maxPrice = 50000.0;

  List<ProductModel> get searchResults => _searchResults;
  bool get isSearching => _isSearching;
  String? get selectedCategory => _selectedCategory;
  String? get selectedDistrict => _selectedDistrict;
  double get maxPrice => _maxPrice;

  void setCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setDistrict(String? district) {
    _selectedDistrict = district;
    notifyListeners();
  }

  void setMaxPrice(double price) {
    _maxPrice = price;
    notifyListeners();
  }

  Future<void> performSearch({String? query}) async {
    _isSearching = true;
    notifyListeners();

    try {
      _searchResults = await _dataSource.searchProducts(
        query: query,
        category: _selectedCategory,
        district: _selectedDistrict,
        maxPrice: _maxPrice,
      );
    } catch (_) {
      _searchResults = [];
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  void clearFilters() {
    _selectedCategory = null;
    _selectedDistrict = null;
    _maxPrice = 50000.0;
    notifyListeners();
  }
}
