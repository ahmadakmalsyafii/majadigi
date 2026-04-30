import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class SignInRequested extends AuthEvent {
  final String email, password;
  const SignInRequested(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}


class GoogleSignInRequested extends AuthEvent {}

class SignOutRequested extends AuthEvent {
  const SignOutRequested();
}


class SignUpRequested extends AuthEvent {
  final String name, email, password, address, NIK;
  final DateTime dateOfBirth;
   const SignUpRequested(this.email, this.password, this.name, this.address, this.NIK, this.dateOfBirth);

  @override
  List<Object> get props => [name, email, password, address, NIK, dateOfBirth];
}