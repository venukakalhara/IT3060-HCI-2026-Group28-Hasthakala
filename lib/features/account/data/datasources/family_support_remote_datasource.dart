import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/shared_models/support_models.dart';

// Thrown when an invitation cannot be accepted (wrong code/phone, expired, used).
class SupportInviteException implements Exception {
  final String message;
  const SupportInviteException(this.message);
  @override
  String toString() => message;
}

// I13 Family Assistance data access
// Every operation here is also checked by firestore.rules - the app hiding
// a button is never the only protection.
class FamilySupportRemoteDataSource {
  final FirebaseFirestore _db;
  final Random _random = Random.secure();

  FamilySupportRemoteDataSource({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _invites =>
      _db.collection(FirestoreCollections.supportInvites);
  CollectionReference<Map<String, dynamic>> get _grants =>
      _db.collection(FirestoreCollections.supportGrants);

  // Artisan (owner) side

  // read: everyone the artisan has authorised (active and revoked).
  Stream<List<SupportGrantModel>> watchGrantsForArtisan(String artisanId) {
    return _grants
        .where('artisanId', isEqualTo: artisanId)
        .snapshots()
        .map((s) => s.docs.map((d) => SupportGrantModel.fromMap(d.data())).toList());
  }

  // read: invitations not yet accepted.
  Stream<List<SupportInviteModel>> watchPendingInvites(String artisanId) {
    return _invites
        .where('artisanId', isEqualTo: artisanId)
        .where('status', isEqualTo: SupportInviteStatus.pending.name)
        .snapshots()
        .map((s) => s.docs.map((d) => SupportInviteModel.fromMap(d.data())).toList());
  }

  // create: a new invitation with a random 6-digit code.
  Future<SupportInviteModel> createInvite({
    required String artisanId,
    required String artisanName,
    required String inviteeName,
    required String relationship,
    required String phone,
    required SupportScopes scopes,
  }) async {
    // If a code is already taken the rules reject the write; try a new code.
    for (var attempt = 1; attempt <= 3; attempt++) {
      final code = (_random.nextInt(900000) + 100000).toString();
      final invite = SupportInviteModel(
        code: code,
        artisanId: artisanId,
        artisanName: artisanName,
        inviteeName: inviteeName,
        relationship: relationship,
        phone: phone,
        scopes: scopes,
      );
      try {
        await _invites.doc(code).set(invite.toMap());
        return invite;
      } on FirebaseException catch (e) {
        if (e.code != 'permission-denied' || attempt == 3) rethrow;
      }
    }
    throw const SupportInviteException('Could not create an invitation. Please try again.');
  }

  // delete: cancel an invitation that has not been accepted.
  Future<void> cancelInvite(String code) => _invites.doc(code).delete();

  // update: change what a supporter may do.
  Future<void> updateScopes(String grantId, SupportScopes scopes) {
    return _grants.doc(grantId).update({
      'scopes': scopes.toMap(),
      'updatedAt': Timestamp.now(),
    });
  }

  // update: revoke access (kept as a record rather than deleted).
  Future<void> revokeGrant(String grantId) {
    return _grants.doc(grantId).update({
      'status': SupportGrantStatus.revoked.name,
      'updatedAt': Timestamp.now(),
    });
  }

  // Supporter side (accepting an invite, watching their grant)

  // supporter accepts an invite - needs the code and the phone number the artisan used
  Future<SupportGrantModel> acceptInvite({
    required String code,
    required String phone,
    required String supporterId,
    required String supporterName,
  }) async {
    // 1. Save the supporter's phone on their OWN account document.
    await _db.collection(FirestoreCollections.users).doc(supporterId).update({
      'phone': phone,
      'updatedAt': Timestamp.now(),
    });

    // 2. Read the invite (rules only allow this if the phone matches).
    final DocumentSnapshot<Map<String, dynamic>> snap;
    try {
      snap = await _invites.doc(code).get();
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        throw const SupportInviteException(
            'This code and phone number do not match a pending invitation. '
            'Check both with the artisan who invited you.');
      }
      rethrow;
    }
    if (!snap.exists || snap.data() == null) {
      throw const SupportInviteException('Invitation not found. Check the code.');
    }
    final invite = SupportInviteModel.fromMap(snap.data()!);
    if (invite.isExpired) {
      throw const SupportInviteException(
          'This invitation has expired. Ask the artisan to send a new one.');
    }
    if (invite.artisanId == supporterId) {
      throw const SupportInviteException('You cannot accept your own invitation.');
    }

    // 3. Create the grant and mark the invite accepted in one write.
    final grant = SupportGrantModel(
      artisanId: invite.artisanId,
      artisanName: invite.artisanName,
      supporterId: supporterId,
      supporterName: supporterName,
      relationship: invite.relationship,
      phone: invite.phone,
      scopes: invite.scopes,
      inviteCode: code,
    );
    final batch = _db.batch();
    batch.set(_grants.doc(grant.id), grant.toMap());
    batch.update(_invites.doc(code), {
      'status': SupportInviteStatus.accepted.name,
      'acceptedBy': supporterId,
    });
    await batch.commit();
    return grant;
  }

  // read (live): the supporter's grant, so a revoke or permission change is shown immediately.
  Stream<SupportGrantModel?> watchGrant(String grantId) {
    return _grants.doc(grantId).snapshots().map(
        (d) => d.exists && d.data() != null ? SupportGrantModel.fromMap(d.data()!) : null);
  }
}
