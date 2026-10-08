import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_collections.dart';

enum PhotoSaveResult { saved, offline, failed }

// I05 profile photo - a small compressed copy kept in profilePhotos/{uid}.
// Cloud Storage needs the paid plan, so the photo is saved as text instead
// (see DEVIATIONS DV6). Kept apart from artisanProfiles and users so the
// profile forms and other members' reads don't change.
class ProfilePhotoRemoteDataSource {
  final FirebaseFirestore _db;

  ProfilePhotoRemoteDataSource({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  // the largest photo the rules accept (as base64 text)
  static const int maxChars = 200000;

  DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      _db.collection(FirestoreCollections.profilePhotos).doc(uid);

  // null when there is no photo
  Stream<Uint8List?> watch(String uid) {
    return _doc(uid).snapshots().map((d) {
      final text = d.data()?['data'];
      if (text is! String || text.isEmpty) return null;
      try {
        return base64Decode(text);
      } catch (_) {
        return null;
      }
    });
  }

  Future<PhotoSaveResult> save(String uid, Uint8List bytes) {
    return _write(() => _doc(uid).set({
          'data': base64Encode(bytes),
          'updatedAt': Timestamp.now(),
        }));
  }

  Future<PhotoSaveResult> remove(String uid) => _write(() => _doc(uid).delete());

  // same idea as the profile save: no answer in 10 seconds = offline
  Future<PhotoSaveResult> _write(Future<void> Function() action) async {
    try {
      await action().timeout(const Duration(seconds: 10));
      return PhotoSaveResult.saved;
    } on TimeoutException {
      return PhotoSaveResult.offline;
    } catch (_) {
      return PhotoSaveResult.failed;
    }
  }
}
