import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/firestore_collections.dart';
import 'app_strings.dart';

// app language (English / Sinhala / Tamil). Saved on the phone and, when
// someone is signed in, in users/{uid}.preferredLanguage.
class LanguageProvider extends ChangeNotifier {
  static const _codeKey = 'language_code';

  String _code = 'en';
  bool _chosen = false;
  bool _loaded = false;

  String get code => _code;
  Locale get locale => Locale(_code);
  bool get chosen => _chosen;
  bool get loaded => _loaded;

  LanguageProvider() {
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_codeKey);
      if (saved != null && AppStrings.supported.contains(saved)) {
        _code = saved;
        _chosen = true;
      }
    } catch (_) {
      // keep English
    }
    _loaded = true;
    notifyListeners();
  }

  // changes the language straight away (so the screen updates as a preview)
  void preview(String code) {
    if (!AppStrings.supported.contains(code) || code == _code) return;
    _code = code;
    notifyListeners();
  }

  // saves the current language
  Future<void> confirm() async {
    _chosen = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_codeKey, _code);
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        await FirebaseFirestore.instance
            .collection(FirestoreCollections.users)
            .doc(uid)
            .update({'preferredLanguage': _code});
      }
    } catch (_) {
      // the choice still works for this session
    }
  }
}
