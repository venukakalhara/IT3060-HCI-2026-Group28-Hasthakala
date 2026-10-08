abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server failure occurred']) : super(message);
}

class AuthFailure extends Failure {
  const AuthFailure([String message = 'Authentication failed']) : super(message);
}

class StorageFailure extends Failure {
  const StorageFailure([String message = 'Storage operation failed']) : super(message);
}
