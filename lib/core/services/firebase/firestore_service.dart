import 'package:cloud_firestore/cloud_firestore.dart';
import '../../errors/exceptions.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  FirebaseFirestore get instance => _firestore;

  // Generic Create / Set
  Future<void> setDocument({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
    bool merge = true,
  }) async {
    try {
      await _firestore.collection(collection).doc(docId).set(data, SetOptions(merge: merge));
    } catch (e) {
      throw ServerException('Failed to write document in $collection: $e');
    }
  }

  // Generic Add (auto ID)
  Future<DocumentReference<Map<String, dynamic>>> addDocument({
    required String collection,
    required Map<String, dynamic> data,
  }) async {
    try {
      return await _firestore.collection(collection).add(data);
    } catch (e) {
      throw ServerException('Failed to add document to $collection: $e');
    }
  }

  // Generic Get Document
  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument({
    required String collection,
    required String docId,
  }) async {
    try {
      return await _firestore.collection(collection).doc(docId).get();
    } catch (e) {
      throw ServerException('Failed to fetch document $docId from $collection: $e');
    }
  }

  // Generic Delete
  Future<void> deleteDocument({
    required String collection,
    required String docId,
  }) async {
    try {
      await _firestore.collection(collection).doc(docId).delete();
    } catch (e) {
      throw ServerException('Failed to delete document $docId from $collection: $e');
    }
  }

  // Generic Stream Collection
  Stream<QuerySnapshot<Map<String, dynamic>>> streamCollection({
    required String collection,
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>> query)? queryBuilder,
  }) {
    Query<Map<String, dynamic>> query = _firestore.collection(collection);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    return query.snapshots();
  }
}
