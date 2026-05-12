import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/exceptions.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/core/utils/mappers/failure_mapper.dart';
import 'package:majadigi/features/auth/domain/entity/user_entity.dart';
import 'package:majadigi/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:majadigi/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> updateProfile(
    String name,
    String NIK,
    DateTime dateOfBirth,
    String email,
    String password,
    String? gender,
    String? address,
  ) async {
    try {
      final userModel = await remoteDataSource.updateProfile(
        name,
        NIK,
        dateOfBirth,
        email,
        password,
        gender,
        address,
      );
      return Right(userModel);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
