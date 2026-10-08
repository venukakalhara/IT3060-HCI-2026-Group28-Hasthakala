class LocalStorageService {
  // Simple in-memory fallback or SharedPreferences adapter
  final Map<String, dynamic> _memoryCache = {};

  Future<void> saveString(String key, String value) async {
    _memoryCache[key] = value;
  }

  Future<String?> getString(String key) async {
    return _memoryCache[key] as String?;
  }

  Future<void> remove(String key) async {
    _memoryCache.remove(key);
  }

  Future<void> clear() async {
    _memoryCache.clear();
  }
}
