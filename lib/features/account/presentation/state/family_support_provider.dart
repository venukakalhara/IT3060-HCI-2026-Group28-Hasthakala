import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../core/shared_models/support_models.dart';
import '../../data/datasources/family_support_remote_datasource.dart';

// I13 Family Assistance state.
class FamilySupportProvider extends ChangeNotifier {
  final FamilySupportRemoteDataSource _dataSource;

  FamilySupportProvider({FamilySupportRemoteDataSource? dataSource})
      : _dataSource = dataSource ?? FamilySupportRemoteDataSource();

  bool _isSaving = false;
  String? _errorMessage;

  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;

  Stream<List<SupportGrantModel>> grantsFor(String artisanId) =>
      _dataSource.watchGrantsForArtisan(artisanId);

  Stream<List<SupportInviteModel>> pendingInvitesFor(String artisanId) =>
      _dataSource.watchPendingInvites(artisanId);

  Stream<SupportGrantModel?> watchGrant(String grantId) => _dataSource.watchGrant(grantId);

  Future<T?> _run<T>(Future<T> Function() action, String failureMessage) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();
    try {
      return await action();
    } on SupportInviteException catch (e) {
      _errorMessage = e.message;
      return null;
    } on FirebaseException catch (e) {
      _errorMessage = e.code == 'unavailable'
          ? 'No internet connection. Check your connection and try again.'
          : failureMessage;
      return null;
    } catch (_) {
      _errorMessage = failureMessage;
      return null;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<SupportInviteModel?> sendInvitation({
    required String artisanId,
    required String artisanName,
    required String inviteeName,
    required String relationship,
    required String phone,
    required SupportScopes scopes,
  }) {
    return _run(
      () => _dataSource.createInvite(
        artisanId: artisanId,
        artisanName: artisanName,
        inviteeName: inviteeName,
        relationship: relationship,
        phone: phone,
        scopes: scopes,
      ),
      'The invitation could not be sent. Please try again.',
    );
  }

  Future<bool> cancelInvitation(String code) async {
    final ok = await _run(() async {
      await _dataSource.cancelInvite(code);
      return true;
    }, 'The invitation could not be cancelled. Please try again.');
    return ok ?? false;
  }

  Future<bool> updateAccess(String grantId, SupportScopes scopes) async {
    final ok = await _run(() async {
      await _dataSource.updateScopes(grantId, scopes);
      return true;
    }, 'Access could not be updated. Please try again.');
    return ok ?? false;
  }

  Future<bool> revokeAccess(String grantId) async {
    final ok = await _run(() async {
      await _dataSource.revokeGrant(grantId);
      return true;
    }, 'Access could not be revoked. Please try again.');
    return ok ?? false;
  }

  Future<SupportGrantModel?> acceptInvitation({
    required String code,
    required String phone,
    required String supporterId,
    required String supporterName,
  }) {
    return _run(
      () => _dataSource.acceptInvite(
        code: code,
        phone: phone,
        supporterId: supporterId,
        supporterName: supporterName,
      ),
      'The invitation could not be accepted. Please try again.',
    );
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
