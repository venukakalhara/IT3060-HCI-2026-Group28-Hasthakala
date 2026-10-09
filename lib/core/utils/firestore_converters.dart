import 'package:cloud_firestore/cloud_firestore.dart';

// all models store dates as Firestore Timestamps
class FirestoreConverters {
  static Timestamp toTimestamp(DateTime value) => Timestamp.fromDate(value);

  static Timestamp? toTimestampOrNull(DateTime? value) =>
      value == null ? null : Timestamp.fromDate(value);

  // reads a Timestamp, or an ISO string from older test data
  static DateTime? toDateTimeOrNull(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  static DateTime toDateTime(dynamic value) =>
      toDateTimeOrNull(value) ?? DateTime.now();
}
