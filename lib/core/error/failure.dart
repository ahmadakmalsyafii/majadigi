import 'package:equatable/equatable.dart';

/// Base abstract class for all Failures in the application.
/// Every feature-specific failure should extend this class.
abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({
    required this.message,
    this.statusCode,
  });

  @override
  List<Object?> get props => [message, statusCode];
}

// ─────────────────────────────────────────────
// General / Infrastructure Failures
// ─────────────────────────────────────────────

/// Network / connectivity issues.
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection. Please check your network.',
    super.statusCode,
  });
}

/// Unexpected server-side errors.
class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'An unexpected server error occurred.',
    super.statusCode,
  });
}

/// Errors related to local cache / shared preferences.
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Cache operation failed.',
    super.statusCode,
  });
}

/// Parsing or serialisation failures.
class ParseFailure extends Failure {
  const ParseFailure({
    super.message = 'Failed to parse data.',
    super.statusCode,
  });
}

// ─────────────────────────────────────────────
// Authentication Failures
// ─────────────────────────────────────────────

/// Wrong email / password combination.
class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure({
    super.message = 'Invalid email or password.',
    super.statusCode = 401,
  });
}

/// The email is already registered.
class EmailAlreadyInUseFailure extends Failure {
  const EmailAlreadyInUseFailure({
    super.message = 'This email is already registered.',
    super.statusCode = 409,
  });
}

/// The provided email address is malformed.
class InvalidEmailFailure extends Failure {
  const InvalidEmailFailure({
    super.message = 'The email address is not valid.',
    super.statusCode = 400,
  });
}

/// The password does not meet the required policy.
class WeakPasswordFailure extends Failure {
  const WeakPasswordFailure({
    super.message = 'Password must be at least 6 characters.',
    super.statusCode = 400,
  });
}

/// The user account has been disabled.
class UserDisabledFailure extends Failure {
  const UserDisabledFailure({
    super.message = 'This account has been disabled.',
    super.statusCode = 403,
  });
}

/// No user is currently signed in.
class UserNotFoundFailure extends Failure {
  const UserNotFoundFailure({
    super.message = 'No account found for the given credentials.',
    super.statusCode = 404,
  });
}

/// The session has expired; the user must re-authenticate.
class SessionExpiredFailure extends Failure {
  const SessionExpiredFailure({
    super.message = 'Your session has expired. Please sign in again.',
    super.statusCode = 401,
  });
}

/// Too many failed authentication attempts.
class TooManyRequestsFailure extends Failure {
  const TooManyRequestsFailure({
    super.message = 'Too many attempts. Please try again later.',
    super.statusCode = 429,
  });
}

// ─────────────────────────────────────────────
// Validation Failures (client-side)
// ─────────────────────────────────────────────

/// Input validation failed (form fields).
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.statusCode = 422});
}

// ─────────────────────────────────────────────
// Permission Failures
// ─────────────────────────────────────────────

/// The user does not have permission to access the resource.
class PermissionFailure extends Failure {
  const PermissionFailure({
    super.message = 'You do not have permission to perform this action.',
    super.statusCode = 403,
  });
}

// ─────────────────────────────────────────────
// Unknown Failure
// ─────────────────────────────────────────────

/// Catch-all for unrecognised failures.
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'An unknown error occurred.',
    super.statusCode,
  });
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'Unauthorized access. Please log in.',
    super.statusCode = 401,
  });
}
