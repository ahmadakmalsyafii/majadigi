
import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/features/auth/domain/entitiy/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure ,UserEntity>> signIn(String email, String password);
  Future<Either<Failure ,UserEntity>> signUp( String email, String password, String name, String phoneNumber,String NIK, DateTime dateOfBirth);
  Future<Either<Failure, UserEntity>> signInWithGoogle();
  Future<Either<Failure, void>> signOut();

  Stream<UserEntity?> get userSession;

  // Future<Either<Failure, UserEntity?>> getCachedUser();
}