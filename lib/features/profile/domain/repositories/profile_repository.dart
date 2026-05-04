import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/features/auth/domain/entitiy/user_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserEntity>> updateProfile(String name, String NIK, DateTime dateOfBirth, String email, String password, String? gender, String? address);
}
