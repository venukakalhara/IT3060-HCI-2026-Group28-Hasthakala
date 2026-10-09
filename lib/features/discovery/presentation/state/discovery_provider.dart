import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/shared_models/product_model.dart';
import '../../data/datasources/discovery_remote_datasource.dart';

class DiscoveryProvider extends ChangeNotifier {
  DiscoveryProvider(
      {DiscoveryRemoteDataSource? dataSource,
      Stream<List<ProductModel>> Function()? featuredProducts})
      : _featuredStream = featuredProducts ??
            (dataSource ?? DiscoveryRemoteDataSource())
                .getFeaturedProductsStream;
  final Stream<List<ProductModel>> Function() _featuredStream;
  StreamSubscription<List<ProductModel>>? _subscription;
  Completer<void>? _refresh;
  Timer? _timeout;
  bool _disposed = false;
  int _generation = 0;
  List<ProductModel> _featuredProducts = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ProductModel> get featuredProducts => _featuredProducts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _finish() {
    _timeout?.cancel();
    if (_refresh != null && !_refresh!.isCompleted) _refresh!.complete();
  }

  Future<void> listenToFeaturedProducts() {
    if (_disposed) return Future.value();
    _finish();
    _subscription?.cancel();
    final generation = ++_generation;
    final refresh = _refresh = Completer<void>();
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    _timeout = Timer(const Duration(seconds: 10), () {
      if (_disposed || generation != _generation) return;
      _isLoading = false;
      _errorMessage = 'Could not load crafts. Please try again.';
      _finish();
      notifyListeners();
    });
    void fail() {
      if (_disposed || generation != _generation) return;
      _isLoading = false;
      _errorMessage = 'Could not load crafts. Please try again.';
      _finish();
      notifyListeners();
    }

    var receivedProducts = false;
    try {
      _subscription = _featuredStream().listen((products) {
        if (_disposed || generation != _generation) return;
        receivedProducts = true;
        _featuredProducts = products;
        _isLoading = false;
        _errorMessage = null;
        _finish();
        notifyListeners();
      }, onError: (Object error) {
        fail();
      }, onDone: () {
        // A closed stream without a snapshot is not a successful empty catalog.
        if (!receivedProducts) fail();
      });
    } catch (_) {
      // Query creation can fail before a stream subscription exists.
      fail();
    }
    return refresh.future;
  }

  @override
  void dispose() {
    _disposed = true;
    _finish();
    _subscription?.cancel();
    super.dispose();
  }
}
