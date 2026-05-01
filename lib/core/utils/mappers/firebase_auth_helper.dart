import 'package:firebase_auth/firebase_auth.dart';
import 'package:majadigi/core/error/exceptions.dart';

AppException mapFirebaseAuthException(FirebaseAuthException e) {
  switch (e.code) {
    case 'user-not-found':
    case 'wrong-password':
    case 'invalid-credential':
      return const InvalidCredentialsException();

    case 'email-already-in-use':
      return const EmailAlreadyInUseException();

    case 'invalid-email':
      return const InvalidEmailException();

    case 'weak-password':
      return const WeakPasswordException();

    case 'user-disabled':
      return const UserDisabledException();

    case 'too-many-requests':
      return const TooManyRequestsException();

    case 'requires-recent-login':
      return const SessionExpiredException();

    default:
      return UnknownAuthException(message: e.message ?? 'Unknown auth error.');
  }
}