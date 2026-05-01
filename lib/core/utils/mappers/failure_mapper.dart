import 'package:majadigi/core/error/exceptions.dart';
import 'package:majadigi/core/error/failure.dart';

Failure mapExceptionToFailure(AppException e) {
  if (e is InvalidCredentialsException) {
    return InvalidCredentialsFailure(message: e.message, statusCode: e.statusCode);
  }
  if (e is EmailAlreadyInUseException) {
    return EmailAlreadyInUseFailure(message: e.message, statusCode: e.statusCode);
  }
  if (e is InvalidEmailException) {
    return InvalidEmailFailure(message: e.message, statusCode: e.statusCode);
  }
  if (e is WeakPasswordException) {
    return WeakPasswordFailure(message: e.message, statusCode: e.statusCode);
  }
  if (e is UserDisabledException) {
    return UserDisabledFailure(message: e.message, statusCode: e.statusCode);
  }
  if (e is UserNotFoundException) {
    return UserNotFoundFailure(message: e.message, statusCode: e.statusCode);
  }
  if (e is SessionExpiredException) {
    return SessionExpiredFailure(message: e.message, statusCode: e.statusCode);
  }
  if (e is TooManyRequestsException) {
    return TooManyRequestsFailure(message: e.message, statusCode: e.statusCode);
  }
  if (e is NetworkException) {
    return NetworkFailure(message: e.message, statusCode: e.statusCode);
  }
  if (e is CacheException) {
    return CacheFailure(message: e.message, statusCode: e.statusCode);
  }
  if (e is ParseException) {
    return ParseFailure(message: e.message, statusCode: e.statusCode);
  }
  if (e is ServerException) {
    return ServerFailure(message: e.message, statusCode: e.statusCode);
  }
  return UnknownFailure(message: e.message, statusCode: e.statusCode);
}