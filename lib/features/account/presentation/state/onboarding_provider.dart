import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// remembers if the first-launch intro was already shown
class OnboardingProvider extends ChangeNotifier {
  static const _key = 'onboarding_seen';

  bool _loaded = false;
  bool _seen = false;

  bool get loaded => _loaded;
  bool get seen => _seen;

  OnboardingProvider() {
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _seen = prefs.getBool(_key) ?? false;
    } catch (_) {
      _seen = false;
    }
    _loaded = true;
    notifyListeners();
  }

  Future<void> markSeen() async {
    _seen = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_key, true);
    } catch (_) {
      // not saved - the intro will just show again next launch
    }
  }
}
