import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import '../../errors/exceptions.dart';

class StorageService {
  final FirebaseStorage _storage;

  StorageService({FirebaseStorage? storage}) : _storage = storage ?? FirebaseStorage.instance;

  Future<String> uploadFile({
    required String path,
    required File file,
    String? contentType,
  }) async {
    try {
      final ref = _storage.ref().child(path);
      final metadata = SettableMetadata(contentType: contentType ?? 'image/jpeg');
      final uploadTask = await ref.putFile(file, metadata);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      throw StorageException('Failed to upload file to $path: $e');
    }
  }

  Future<String> uploadBytes({
    required String path,
    required Uint8List bytes,
    String? contentType,
  }) async {
    try {
      final ref = _storage.ref().child(path);
      final metadata = SettableMetadata(contentType: contentType ?? 'image/jpeg');
      final uploadTask = await ref.putData(bytes, metadata);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      throw StorageException('Failed to upload bytes to $path: $e');
    }
  }

  Future<void> deleteFile(String path) async {
    try {
      final ref = _storage.ref().child(path);
      await ref.delete();
    } catch (e) {
      throw StorageException('Failed to delete file at $path: $e');
    }
  }
}
