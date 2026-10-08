class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'An unexpected server error occurred']);

  @override
  String toString() => 'ServerException: $message';
}

class AuthException implements Exception {
  final String message;
  const AuthException([this.message = 'Authentication failed']);

  @override
  String toString() => 'AuthException: $message';
}

class StorageException implements Exception {
  final String message;
  const StorageException([this.message = 'File upload/storage operation failed']);

  @override
  String toString() => 'StorageException: $message';
}
