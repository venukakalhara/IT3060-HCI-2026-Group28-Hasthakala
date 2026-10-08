import 'package:flutter/material.dart';
import '../../../../core/shared_models/order_model.dart';
import '../../data/datasources/checkout_remote_datasource.dart';

/// Assigned to: DISSANAYAKE D. M. S. D.
/// Branch: feature/buyer-purchase
class OrderTrackingProvider extends ChangeNotifier {
  final CheckoutRemoteDataSource _dataSource;

  OrderTrackingProvider({CheckoutRemoteDataSource? dataSource})
      : _dataSource = dataSource ?? CheckoutRemoteDataSource();

  OrderModel? _currentOrder;
  bool _isLoading = true;

  OrderModel? get currentOrder => _currentOrder;
  bool get isLoading => _isLoading;

  void trackOrder(String orderId) {
    _isLoading = true;
    notifyListeners();

    _dataSource.streamOrder(orderId).listen((order) {
      _currentOrder = order;
      _isLoading = false;
      notifyListeners();
    });
  }
}
