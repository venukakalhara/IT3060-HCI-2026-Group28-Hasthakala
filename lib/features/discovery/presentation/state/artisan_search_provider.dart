import 'package:flutter/foundation.dart';
import '../../../../core/shared_models/artisan_profile_model.dart';
import '../../data/datasources/discovery_remote_datasource.dart';
import '../../data/discovery_filters.dart';

typedef ArtisanLoader = Future<List<ArtisanProfileModel>> Function();

class ArtisanSearchProvider extends ChangeNotifier {
  ArtisanSearchProvider({ArtisanLoader? load})
      : _load = load ?? (() => DiscoveryRemoteDataSource().searchArtisans());

  final ArtisanLoader _load;
  List<ArtisanProfileModel> _artisans = [];
  String _query = '';
  String? _category;
  bool _verifiedOnly = false;
  bool _loading = false;
  bool _failed = false;
  bool _disposed = false;
  int _request = 0;

  bool get loading => _loading;
  bool get failed => _failed;
  String? get category => _category;
  bool get verifiedOnly => _verifiedOnly;

  List<ArtisanProfileModel> get results {
    final term = _query.trim().toLowerCase();
    return List.unmodifiable(_artisans.where((artisan) =>
        (!_verifiedOnly || artisan.verified) &&
        (_category == null ||
            discoveryCategoryKey(artisan.craftType) == _category) &&
        (term.isEmpty ||
            '${artisan.displayName} ${artisan.craftType} ${artisan.about} ${artisan.location}'
                .toLowerCase()
                .contains(term))));
  }

  void setQuery(String query) {
    if (_disposed || _query == query) return;
    _query = query;
    notifyListeners();
  }

  void setCategory(String? category) {
    if (_disposed) return;
    _category = discoveryCategoryKey(category);
    notifyListeners();
  }

  void setVerifiedOnly(bool value) {
    if (_disposed) return;
    _verifiedOnly = value;
    notifyListeners();
  }

  Future<void> refresh() async {
    if (_disposed) return;
    final request = ++_request;
    _loading = true;
    _failed = false;
    notifyListeners();
    try {
      final artisans = await _load();
      if (_disposed || request != _request) return;
      _artisans = List.of(artisans);
    } catch (_) {
      if (_disposed || request != _request) return;
      _failed = true;
    } finally {
      if (!_disposed && request == _request) {
        _loading = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
