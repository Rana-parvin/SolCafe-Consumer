abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'A server error occurred.']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'A cache error occurred.']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'An authentication error occurred.']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection available.']);
}

class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Validation error occurred.']);
}
