import 'package:flutter/material.dart';
import '../../../../core/shared_models/product_model.dart';
import '../../data/datasources/discovery_remote_datasource.dart';

/// Assigned to: JAYAWARDANA V. K. A.
/// Branch: feature/buyer-discovery
class DiscoveryProvider extends ChangeNotifier {
  final DiscoveryRemoteDataSource _dataSource;

  DiscoveryProvider({DiscoveryRemoteDataSource? dataSource})
      : _dataSource = dataSource ?? DiscoveryRemoteDataSource();

  List<ProductModel> _featuredProducts = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ProductModel> get featuredProducts => _featuredProducts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void listenToFeaturedProducts() {
    _isLoading = true;
    notifyListeners();

    _dataSource.getFeaturedProductsStream().listen(
      (products) {
        _featuredProducts = products;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (e) {
        _isLoading = false;
        _errorMessage = e.toString();
        notifyListeners();
      },
    );
  }
}
