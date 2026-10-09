import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/firestore_collections.dart';
import '../../../core/shared_models/artisan_profile_model.dart';

// Cart lines only keep the artisanId, so the artisan's name, place and
// verified badge come from artisanProfiles. Each profile is read once.
class ArtisanInfoCache {
  static final Map<String, Future<ArtisanProfileModel?>> _cache = {};

  static Future<ArtisanProfileModel?> get(String artisanId) {
    if (artisanId.isEmpty) return Future.value(null);
    return _cache.putIfAbsent(artisanId, () => _load(artisanId));
  }

  static Future<ArtisanProfileModel?> _load(String artisanId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection(FirestoreCollections.artisanProfiles)
          .doc(artisanId)
          .get();
      final data = doc.data();
      return data == null ? null : ArtisanProfileModel.fromMap(data, doc.id);
    } catch (_) {
      // try again next time instead of keeping the failure
      _cache.remove(artisanId);
      return null;
    }
  }
}
