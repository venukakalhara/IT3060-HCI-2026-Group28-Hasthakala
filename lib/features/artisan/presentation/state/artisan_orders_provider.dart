import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/shared_models/order_model.dart';
import '../../data/datasources/artisan_order_datasource.dart';

/// Assigned to: KUMARI R. P. G. D.
/// Branch: feature/artisan-management
class ArtisanOrdersProvider extends ChangeNotifier {
  final ArtisanOrderDataSource _dataSource;
  StreamSubscription<List<OrderModel>>? _ordersSubscription;

  ArtisanOrdersProvider({ArtisanOrderDataSource? dataSource})
      : _dataSource = dataSource ?? ArtisanOrderDataSource();

  List<OrderModel> _incomingOrders = [];
  bool _isLoading = false;
  String? _errorMessage;
  OrderStatus? _selectedStatus;
  String _searchQuery = '';

  List<OrderModel> get incomingOrders => List.unmodifiable(_incomingOrders);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  OrderStatus? get selectedStatus => _selectedStatus;
  String get searchQuery => _searchQuery;

  // Status-filtered and search-filtered list for UI
  List<OrderModel> get filteredOrders {
    return _incomingOrders.where((order) {
      if (_selectedStatus != null && order.status != _selectedStatus) {
        return false;
      }
      if (_searchQuery.trim().isNotEmpty) {
        final q = _searchQuery.trim().toLowerCase();
        final matchesId = order.id.toLowerCase().contains(q);
        final matchesBuyer = order.buyerName.toLowerCase().contains(q);
        final matchesRecipient = order.recipientName.toLowerCase().contains(q);
        final matchesItem = order.items.any((item) => item.title.toLowerCase().contains(q));
        return matchesId || matchesBuyer || matchesRecipient || matchesItem;
      }
      return true;
    }).toList();
  }

  int get totalCount => _incomingOrders.length;
  int get pendingCount => _incomingOrders.where((o) => o.status == OrderStatus.pending).length;
  int get confirmedCount => _incomingOrders.where((o) => o.status == OrderStatus.confirmed).length;
  int get preparingCount => _incomingOrders.where((o) => o.status == OrderStatus.preparing).length;
  int get shippedCount => _incomingOrders.where((o) => o.status == OrderStatus.shipped).length;
  int get deliveredCount => _incomingOrders.where((o) => o.status == OrderStatus.delivered).length;
  int get cancelledCount => _incomingOrders.where((o) => o.status == OrderStatus.cancelled).length;
  int get activeOrdersCount => _incomingOrders
      .where((o) => o.status != OrderStatus.delivered && o.status != OrderStatus.cancelled)
      .length;

  int countForStatus(OrderStatus? status) {
    if (status == null) return totalCount;
    return _incomingOrders.where((o) => o.status == status).length;
  }

  void listenToArtisanOrders(String artisanId) {
    _ordersSubscription?.cancel();
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    _ordersSubscription = _dataSource.getArtisanOrders(artisanId).listen(
      (orders) {
        // Sort descending by creation date
        orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        _incomingOrders = orders;
        _isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        _isLoading = false;
        _errorMessage = 'Could not load orders: $error';
        notifyListeners();
      },
    );
  }

  @Deprecated('Use listenToArtisanOrders(artisanId)')
  void listenToOrders() {
    _ordersSubscription?.cancel();
    _isLoading = true;
    notifyListeners();

    _ordersSubscription = _dataSource.getIncomingOrders().listen((orders) {
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      _incomingOrders = orders;
      _isLoading = false;
      notifyListeners();
    });
  }

  void setStatusFilter(OrderStatus? status) {
    _selectedStatus = status;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<bool> changeOrderStatus({
    required String orderId,
    required OrderStatus status,
    String? updatedByUid,
    String? cancelReason,
  }) async {
    try {
      await _dataSource.updateOrderStatus(
        orderId: orderId,
        status: status,
        updatedByUid: updatedByUid,
        cancelReason: cancelReason,
      );
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update order status: $e';
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _ordersSubscription?.cancel();
    super.dispose();
  }
}
