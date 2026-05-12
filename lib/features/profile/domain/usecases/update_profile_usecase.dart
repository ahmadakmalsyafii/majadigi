import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/features/auth/domain/entity/user_entity.dart';
import 'package:majadigi/features/profile/domain/repositories/profile_repository.dart';

@lazySingleton
class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(
    String name,
    String NIK,
    DateTime dateOfBirth,
    String email,
    String password,
    String? gender,
    String? address,
  ) {
    return repository.updateProfile(
      name,
      NIK,
      dateOfBirth,
      email,
      password,
      gender,
      address,
    );
  }
}
