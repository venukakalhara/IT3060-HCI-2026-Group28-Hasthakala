import 'package:flutter/material.dart';

import '../../../../core/shared_models/order_model.dart';
import '../../data/datasources/checkout_remote_datasource.dart';
import '../../data/delivery_details.dart';

/// Assigned to: DISSANAYAKE D. M. S. D.
/// Branch: feature/buyer-purchase
enum PlaceFailure { network, stock }

class PlaceResult {
  final List<OrderModel> orders;
  final PlaceFailure? failure;
  final List<String> soldOut;

  const PlaceResult.placed(this.orders)
      : failure = null,
        soldOut = const [];

  const PlaceResult.failed(this.failure, [this.soldOut = const []])
      : orders = const [];

  bool get ok => failure == null;
}

// I07 checkout state - the current step and what the buyer picked
// the typed delivery details stay in the screen's text fields
class CheckoutProvider extends ChangeNotifier {
  CheckoutProvider({CheckoutRemoteDataSource Function()? remote})
      : _makeRemote = remote ?? (() => CheckoutRemoteDataSource());

  final CheckoutRemoteDataSource Function() _makeRemote;
  bool _disposed = false;

  // 0 review, 1 delivery, 2 payment, 3 confirm
  int _step = 0;
  String _paymentMethod = PaymentMethods.cashOnDelivery;
  bool _checked = false;
  bool _saveAddress = true;
  bool _placing = false;

  int get step => _step;
  String get paymentMethod => _paymentMethod;
  bool get checked => _checked;
  bool get saveAddress => _saveAddress;
  bool get placing => _placing;

  void goTo(int step) {
    _step = step.clamp(0, 3);
    _notify();
  }

  void setPaymentMethod(String method) {
    _paymentMethod = method;
    _notify();
  }

  void setChecked(bool value) {
    _checked = value;
    _notify();
  }

  void setSaveAddress(bool value) {
    _saveAddress = value;
    _notify();
  }

  Future<PlaceResult> placeOrder({
    required String buyerId,
    required String buyerName,
    required List<OrderItemModel> items,
    required DeliveryDetails address,
    required double deliveryFee,
    String? deliveryNote,
  }) async {
    _placing = true;
    _notify();
    final remote = _makeRemote();
    try {
      final orders = await remote.placeOrders(
        buyerId: buyerId,
        buyerName: buyerName,
        items: items,
        address: address,
        paymentMethod: _paymentMethod,
        deliveryFee: deliveryFee,
        deliveryNote: deliveryNote,
      );
      if (_saveAddress) {
        // orders are already saved, so this error is ignored
        try {
          await remote.saveDefaultAddress(buyerId, address);
        } catch (_) {}
      }
      return PlaceResult.placed(orders);
    } on OutOfStockException catch (e) {
      return PlaceResult.failed(PlaceFailure.stock, e.titles);
    } catch (_) {
      return PlaceResult.failed(PlaceFailure.network);
    } finally {
      _placing = false;
      _notify();
    }
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
