import 'package:cloud_firestore/cloud_firestore.dart';

/// Shared date helpers so every model stores dates the same way:
/// as Firestore Timestamps (see docs/FIREBASE_SCHEMA.md).
class FirestoreConverters {
  static Timestamp toTimestamp(DateTime value) => Timestamp.fromDate(value);

  static Timestamp? toTimestampOrNull(DateTime? value) =>
      value == null ? null : Timestamp.fromDate(value);

  /// Reads a date stored as a Timestamp (current schema) or as an
  /// ISO-8601 string (older scaffold test data).
  static DateTime? toDateTimeOrNull(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  static DateTime toDateTime(dynamic value) =>
      toDateTimeOrNull(value) ?? DateTime.now();
}
