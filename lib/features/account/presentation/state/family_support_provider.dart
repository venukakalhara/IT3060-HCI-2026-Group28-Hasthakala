import 'package:flutter/material.dart';
import '../../data/datasources/family_support_datasource.dart';

/// Assigned to: WANIGATHUNGA Y. J.
/// Branch: feature/account-support
class FamilySupportProvider extends ChangeNotifier {
  final FamilySupportDataSource _dataSource;

  FamilySupportProvider({FamilySupportDataSource? dataSource})
      : _dataSource = dataSource ?? FamilySupportDataSource();

  bool _isSaving = false;

  bool get isSaving => _isSaving;

  Future<bool> saveAssistedSettings({
    required String elderArtisanUid,
    required String assistantEmail,
    required bool canManageOrders,
    required bool canManageListings,
    required bool canReplyMessages,
  }) async {
    _isSaving = true;
    notifyListeners();

    try {
      await _dataSource.delegatePermissions(
        elderArtisanUid: elderArtisanUid,
        assistantEmail: assistantEmail,
        canManageOrders: canManageOrders,
        canManageListings: canManageListings,
        canReplyMessages: canReplyMessages,
      );
      _isSaving = false;
      notifyListeners();
      return true;
    } catch (_) {
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }
}
