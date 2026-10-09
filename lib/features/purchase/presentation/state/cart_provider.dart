import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/shared_models/order_model.dart';
import '../../../../core/shared_models/product_model.dart';
import '../../data/datasources/cart_remote_datasource.dart';

/// Assigned to: DISSANAYAKE D. M. S. D.
/// Branch: feature/buyer-purchase
// I06 cart. Saved in users/{uid}/cart so it is still there after the app
// closes. Product details (Member 1) uses addProduct, quantityFor and
// totalItemCount - keep those names and what they do.
class CartProvider extends ChangeNotifier {
  CartProvider({CartRemoteDataSource Function()? remote})
      : _makeRemote = remote ?? (() => CartRemoteDataSource());

  // Islandwide delivery, charged once per checkout (hi-fi HF2 / HF3).
  // Packaging is free.
  static const double deliveryFee = 450.0;

  // Firestore is only touched after someone signs in, so the cart also
  // works on its own (Member 1's widget tests use it like that).
  final CartRemoteDataSource Function() _makeRemote;
  CartRemoteDataSource? _remote;
  StreamSubscription<List<OrderItemModel>>? _subscription;
  String? _uid;
  bool _disposed = false;

  final List<OrderItemModel> _cartItems = [];
  // stock seen on product details, so the cart can't go over it
  final Map<String, int> _stockLimits = {};
  bool _isLoading = false;

  List<OrderItemModel> get cartItems => List.unmodifiable(_cartItems);
  bool get isLoading => _isLoading;

  double get subtotalLkr => _cartItems.fold(
      0.0, (sum, item) => sum + (item.unitPriceLkr * item.quantity));

  double get deliveryFeeLkr => _cartItems.isEmpty ? 0.0 : deliveryFee;

  double get totalLkr => subtotalLkr + deliveryFeeLkr;

  int get totalItemCount =>
      _cartItems.fold(0, (sum, item) => sum + item.quantity);

  // how many different workshops the items come from
  int get artisanCount => _cartItems.map((item) => item.artisanId).toSet().length;

  int quantityFor(String productId) => _cartItems
      .where((item) => item.productId == productId)
      .fold(0, (total, item) => total + item.quantity);

  // Called from app.dart whenever the signed-in account changes.
  void setAccount(String? uid) {
    if (uid == _uid) return;
    _uid = uid;
    _subscription?.cancel();
    _subscription = null;
    _cartItems.clear();
    _stockLimits.clear();
    _isLoading = uid != null;
    if (uid != null) {
      _remote ??= _makeRemote();
      _subscription = _remote!.streamCartItems(uid).listen((items) {
        _cartItems
          ..clear()
          ..addAll(items);
        _isLoading = false;
        _notify();
      }, onError: (_) {
        _isLoading = false;
        _notify();
      });
    }
    // the proxy provider calls this while widgets are building
    Future.microtask(_notify);
  }

  bool addProduct(ProductModel product, {int quantity = 1}) {
    if (!product.isAvailable ||
        product.stockQuantity <= 0 ||
        quantity <= 0 ||
        quantityFor(product.id) + quantity > product.stockQuantity) {
      return false;
    }
    _stockLimits[product.id] = product.stockQuantity;
    addItem(OrderItemModel(
        productId: product.id,
        title: product.title,
        unitPriceLkr: product.priceLkr,
        quantity: quantity,
        imageUrl: product.imageUrls.isEmpty ? null : product.imageUrls.first,
        artisanId: product.artisanId));
    return true;
  }

  void addItem(OrderItemModel item) {
    if (item.quantity <= 0 ||
        (_stockLimits.containsKey(item.productId) &&
            quantityFor(item.productId) + item.quantity >
                _stockLimits[item.productId]!)) {
      return;
    }
    final index =
        _cartItems.indexWhere((element) => element.productId == item.productId);
    final OrderItemModel saved;
    if (index >= 0) {
      final existing = _cartItems[index];
      saved = _withQuantity(existing, existing.quantity + item.quantity);
      _cartItems[index] = saved;
    } else {
      saved = _withQuantity(item, item.quantity);
      _cartItems.add(saved);
    }
    _notify();
    _save(saved);
  }

  void updateQuantity(String productId, int newQuantity) {
    if (_stockLimits.containsKey(productId) &&
        newQuantity > _stockLimits[productId]!) {
      return;
    }
    if (newQuantity <= 0) {
      removeItem(productId);
      return;
    }
    final index =
        _cartItems.indexWhere((element) => element.productId == productId);
    if (index >= 0) {
      final saved = _withQuantity(_cartItems[index], newQuantity);
      _cartItems[index] = saved;
      _notify();
      _save(saved);
    }
  }

  void removeItem(String productId) {
    _cartItems.removeWhere((item) => item.productId == productId);
    _stockLimits.remove(productId);
    _notify();
    _delete(productId);
  }

  // after an order is placed, only the ordered lines leave the cart
  void removeItems(Iterable<String> productIds) {
    final ids = productIds.toSet();
    _cartItems.removeWhere((item) => ids.contains(item.productId));
    _notify();
    for (final id in ids) {
      _stockLimits.remove(id);
      _delete(id);
    }
  }

  void clearCart() {
    removeItems(_cartItems.map((item) => item.productId).toList());
  }

  OrderItemModel _withQuantity(OrderItemModel item, int quantity) {
    return OrderItemModel(
      productId: item.productId,
      title: item.title,
      unitPriceLkr: item.unitPriceLkr,
      quantity: quantity,
      imageUrl: item.imageUrl,
      artisanId: item.artisanId,
      addedAt: item.addedAt ?? DateTime.now(),
    );
  }

  // Firestore keeps writes made offline and sends them later,
  // so a failed save here is ignored.
  Future<void> _save(OrderItemModel item) async {
    final uid = _uid;
    final remote = _remote;
    if (uid == null || remote == null) return;
    try {
      await remote.addToCart(userId: uid, item: item);
    } catch (_) {}
  }

  Future<void> _delete(String productId) async {
    final uid = _uid;
    final remote = _remote;
    if (uid == null || remote == null) return;
    try {
      await remote.removeFromCart(userId: uid, productId: productId);
    } catch (_) {}
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _subscription?.cancel();
    super.dispose();
  }
}
