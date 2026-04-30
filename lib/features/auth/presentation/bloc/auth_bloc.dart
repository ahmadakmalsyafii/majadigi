import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:majadigi/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:majadigi/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:majadigi/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:majadigi/features/auth/presentation/bloc/auth_event.dart';
import 'package:majadigi/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase _signIn;
  final SignOutUsecase _signOut;
  final SignUpUsecase _signUp;


  AuthBloc({
    required SignInUseCase signIn,
    required SignOutUsecase signOut,
    required SignUpUsecase signUp,
  })  : _signIn = signIn,
        _signOut = signOut,
        _signUp = signUp,
        super(const AuthInitial()) {
    // on<AuthCheckRequested>(_onCheckRequested);
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignOutRequested>(_onSignOutRequested);
  }

  // ─── Check cached session ────────────────────────────────────────────────

  // Future<void> _onCheckRequested(
  //     AuthCheckRequested event,
  //     Emitter<AuthState> emit,
  //     ) async {
  //   emit(const AuthLoading());
  //   final result = await _getCachedUser();
  //   result.fold(
  //         (failure) => emit(const AuthUnauthenticated()),
  //         (user) => user != null
  //         ? emit(AuthAuthenticated(user))
  //         : emit(const AuthUnauthenticated()),
  //   );
  // }

  // ─── Sign In ─────────────────────────────────────────────────────────────

  Future<void> _onSignInRequested(
      SignInRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());
    final result = await _signIn(
      event.email, event.password,
    );

    result.fold(
          (failure) => emit(AuthFailure(failure)),
          (user) => emit(AuthAuthenticated(user)),
    );
  }

  // ─── Register ────────────────────────────────────────────────────────────

  Future<void> _onSignUpRequested(
      SignUpRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());
    final result = await _signUp(
      event.name,
      event.email,
      event.password,
      event.phoneNumber,
      event.NIK,
      event.dateOfBirth,
    );
    result.fold(
          (failure) => emit(AuthFailure(failure)),
          (user) => emit(AuthAuthenticated(user)),
    );
  }

  // ─── Sign Out ────────────────────────────────────────────────────────────

  Future<void> _onSignOutRequested(
      SignOutRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());
    final result = await _signOut();
    result.fold(
          (failure) => emit(AuthFailure(failure)),
          (_) => emit(const AuthUnauthenticated()),
    );
  }
}