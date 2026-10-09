import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Device-local, account-scoped saved product IDs. Product data is loaded fresh.
class FavoritesProvider extends ChangeNotifier {
  FavoritesProvider({Future<SharedPreferences> Function()? preferences})
      : _preferences = preferences ?? SharedPreferences.getInstance;
  final Future<SharedPreferences> Function() _preferences;
  String? _account;
  String? get account => _account;
  Set<String> _ids = {};
  Set<String> get ids => Set.unmodifiable(_ids);
  bool _busy = true;
  bool get busy => _busy;
  String? _error;
  String? get error => _error;
  int _generation = 0;
  bool _disposed = false;
  bool contains(String id) => _ids.contains(id);

  Future<void> setAccount(String? uid, {bool reload = false}) async {
    final account = uid ?? 'guest';
    if (_account == account && !reload) return;
    _account = account;
    final generation = ++_generation;
    _ids = {};
    _busy = true;
    _error = null;
    // ProxyProvider may call this while its ancestors are rebuilding.
    await Future<void>.delayed(Duration.zero);
    if (_disposed || generation != _generation) return;
    notifyListeners();
    try {
      final prefs = await _preferences();
      if (_disposed || generation != _generation) return;
      _ids =
          (prefs.getStringList('discovery.favorites.$account') ?? []).toSet();
    } catch (_) {
      if (_disposed || generation != _generation) return;
      _error = 'Could not load saved crafts. Try again.';
    } finally {
      if (!_disposed && generation == _generation) {
        _busy = false;
        notifyListeners();
      }
    }
  }

  Future<bool> toggle(String id) async {
    if (_busy || _error != null || _account == null || id.isEmpty) return false;
    final generation = _generation;
    final key = 'discovery.favorites.$_account';
    final next = {..._ids};
    if (!next.remove(id)) next.add(id);
    _busy = true;
    notifyListeners();
    try {
      final prefs = await _preferences();
      if (!await prefs.setStringList(key, next.toList()))
        throw StateError('Save failed');
      if (_disposed || generation != _generation) return false;
      _ids = next;
      return true;
    } catch (_) {
      return false;
    } finally {
      if (!_disposed && generation == _generation) {
        _busy = false;
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
