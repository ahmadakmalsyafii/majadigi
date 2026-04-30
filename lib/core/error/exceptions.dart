/// Base app exception. All datasource exceptions extend this.
class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException({required this.message, this.statusCode});

  @override
  String toString() => 'AppException: $message (status: $statusCode)';
}

// ─────────────────────────────────────────────
// Network / Server Exceptions
// ─────────────────────────────────────────────

class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection.',
    super.statusCode,
  });
}

class ServerException extends AppException {
  const ServerException({
    super.message = 'Server error occurred.',
    super.statusCode,
  });
}

class CacheException extends AppException {
  const CacheException({
    super.message = 'Cache operation failed.',
    super.statusCode,
  });
}

class ParseException extends AppException {
  const ParseException({
    super.message = 'Failed to parse response.',
    super.statusCode,
  });
}

// ─────────────────────────────────────────────
// Auth Exceptions (mirror Firebase error codes)
// ─────────────────────────────────────────────

class InvalidCredentialsException extends AppException {
  const InvalidCredentialsException({
    super.message = 'Invalid email or password.',
    super.statusCode = 401,
  });
}

class EmailAlreadyInUseException extends AppException {
  const EmailAlreadyInUseException({
    super.message = 'Email is already in use.',
    super.statusCode = 409,
  });
}

class InvalidEmailException extends AppException {
  const InvalidEmailException({
    super.message = 'Invalid email format.',
    super.statusCode = 400,
  });
}

class WeakPasswordException extends AppException {
  const WeakPasswordException({
    super.message = 'Password is too weak.',
    super.statusCode = 400,
  });
}

class UserDisabledException extends AppException {
  const UserDisabledException({
    super.message = 'Account is disabled.',
    super.statusCode = 403,
  });
}

class UserNotFoundException extends AppException {
  const UserNotFoundException({
    super.message = 'User not found.',
    super.statusCode = 404,
  });
}

class SessionExpiredException extends AppException {
  const SessionExpiredException({
    super.message = 'Session expired. Please sign in again.',
    super.statusCode = 401,
  });
}

class TooManyRequestsException extends AppException {
  const TooManyRequestsException({
    super.message = 'Too many attempts. Try again later.',
    super.statusCode = 429,
  });
}

class UnknownAuthException extends AppException {
  const UnknownAuthException({
    super.message = 'An unknown authentication error occurred.',
    super.statusCode,
  });
}
