class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Server Exception Occurred']);
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Cache Exception Occurred']);
}

class AuthException implements Exception {
  final String message;
  const AuthException([this.message = 'Authentication Exception Occurred']);
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'Network Exception Occurred']);
}

class ValidationException implements Exception {
  final String message;
  const ValidationException([this.message = 'Validation Exception Occurred']);
}
