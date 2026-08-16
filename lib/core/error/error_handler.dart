import 'package:solcafe/core/error/exceptions.dart';
import 'package:solcafe/core/error/failures.dart';

class ErrorHandler {
  static Failure handle(Object error) {
    if (error is AuthException) {
      return AuthFailure(error.message);
    } else if (error is ServerException) {
      return ServerFailure(error.message);
    } else if (error is CacheException) {
      return CacheFailure(error.message);
    } else if (error is NetworkException) {
      return NetworkFailure(error.message);
    } else if (error is ValidationException) {
      return ValidationFailure(error.message);
    }
    return ServerFailure(error.toString());
  }
}
