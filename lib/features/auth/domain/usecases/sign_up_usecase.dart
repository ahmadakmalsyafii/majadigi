
import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/features/auth/domain/entitiy/user_entity.dart';
import 'package:majadigi/features/auth/domain/repositories/auth_repository.dart';

class SignUpUsecase {
  final AuthRepository repository;

  SignUpUsecase(this.repository);

  Future<Either<Failure, UserEntity>> call(String email, String password, String name,String address, String NIK, DateTime dateOfBirth) async {
    return await repository.signUp(
      email,
      password,
      name,
      address,
      NIK,
      dateOfBirth,
    );
  }
}