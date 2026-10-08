import 'package:flutter/material.dart';
import '../../../../core/shared_models/order_model.dart';
import '../../data/datasources/checkout_remote_datasource.dart';

/// Assigned to: DISSANAYAKE D. M. S. D.
/// Branch: feature/buyer-purchase
class CheckoutProvider extends ChangeNotifier {
  final CheckoutRemoteDataSource _dataSource;

  CheckoutProvider({CheckoutRemoteDataSource? dataSource})
      : _dataSource = dataSource ?? CheckoutRemoteDataSource();

  String _shippingAddress = '';
  String _contactPhone = '';
  String _paymentMethod = 'COD'; // Cash On Delivery / Card / Bank
  bool _isProcessing = false;
  String? _placedOrderId;

  String get shippingAddress => _shippingAddress;
  String get contactPhone => _contactPhone;
  String get paymentMethod => _paymentMethod;
  bool get isProcessing => _isProcessing;
  String? get placedOrderId => _placedOrderId;

  void setAddress(String address) {
    _shippingAddress = address;
    notifyListeners();
  }

  void setPhone(String phone) {
    _contactPhone = phone;
    notifyListeners();
  }

  void setPaymentMethod(String method) {
    _paymentMethod = method;
    notifyListeners();
  }

  Future<bool> submitOrder({
    required String buyerId,
    required String buyerName,
    required List<OrderItemModel> items,
    required double totalAmountLkr,
  }) async {
    _isProcessing = true;
    notifyListeners();

    try {
      final order = OrderModel(
        id: '',
        buyerId: buyerId,
        buyerName: buyerName,
        items: items,
        totalAmountLkr: totalAmountLkr,
        shippingAddress: _shippingAddress,
        contactPhone: _contactPhone,
        paymentMethod: _paymentMethod,
        status: OrderStatus.pending,
      );

      _placedOrderId = await _dataSource.placeOrder(order);
      _isProcessing = false;
      notifyListeners();
      return true;
    } catch (_) {
      _isProcessing = false;
      notifyListeners();
      return false;
    }
  }
}
