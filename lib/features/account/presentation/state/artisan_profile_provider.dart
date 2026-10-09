import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/shared_models/artisan_profile_model.dart';
import '../../data/datasources/artisan_profile_remote_datasource.dart';

enum ProfileSaveResult { saved, offline, failed }

class ArtisanProfileProvider extends ChangeNotifier {
  final ArtisanProfileRemoteDataSource _dataSource;

  ArtisanProfileProvider({ArtisanProfileRemoteDataSource? dataSource})
      : _dataSource = dataSource ?? ArtisanProfileRemoteDataSource();

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  Stream<ArtisanProfileModel?> watchProfile(String uid) => _dataSource.watchProfile(uid);

  Stream<String?> watchCoverStyle(String uid) => _dataSource.watchCoverStyle(uid);

  // same offline check as save(), but without the saving overlay
  Future<ProfileSaveResult> saveCoverStyle(String uid, String style) async {
    try {
      await _dataSource.updateCoverStyle(uid, style).timeout(const Duration(seconds: 10));
      return ProfileSaveResult.saved;
    } on TimeoutException {
      return ProfileSaveResult.offline;
    } catch (_) {
      return ProfileSaveResult.failed;
    }
  }

  Future<ProfileSaveResult> save(ArtisanProfileModel profile) async {
    _isSaving = true;
    notifyListeners();
    try {
      // firestore keeps offline writes in a queue, so no answer in time = offline
      await _dataSource.updateProfile(profile).timeout(const Duration(seconds: 10));
      return ProfileSaveResult.saved;
    } on TimeoutException {
      return ProfileSaveResult.offline;
    } catch (_) {
      return ProfileSaveResult.failed;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
