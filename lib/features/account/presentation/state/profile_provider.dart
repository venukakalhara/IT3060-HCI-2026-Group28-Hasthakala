import 'package:flutter/material.dart';
import '../../../../core/shared_models/user_model.dart';
import '../../data/datasources/profile_remote_datasource.dart';

/// Assigned to: WANIGATHUNGA Y. J.
/// Branch: feature/account-support
class ProfileProvider extends ChangeNotifier {
  final ProfileRemoteDataSource _dataSource;

  ProfileProvider({ProfileRemoteDataSource? dataSource})
      : _dataSource = dataSource ?? ProfileRemoteDataSource();

  UserModel? _profile;
  bool _isLoading = false;

  UserModel? get profile => _profile;
  bool get isLoading => _isLoading;

  void listenToProfile(String uid) {
    _isLoading = true;
    notifyListeners();

    _dataSource.streamUserProfile(uid).listen((user) {
      _profile = user;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> updateProfile(UserModel updatedUser) async {
    await _dataSource.updateProfile(updatedUser);
  }
}
