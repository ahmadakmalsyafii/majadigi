import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:majadigi/core/error/exceptions.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/core/utils/mappers/failure_mapper.dart';
import 'package:majadigi/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:majadigi/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:majadigi/features/auth/domain/entitiy/user_entity.dart';
import 'package:majadigi/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final FirebaseAuth firebaseAuth;
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.firebaseAuth,
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> signIn(
    String email,
    String password,
  ) async {
    try {
      final userModel = await remoteDataSource.signIn(email, password);
      await localDataSource.cacheUser(userModel);

      return Right(
        UserEntity(
          uid: userModel.uid,
          email: userModel.email,
          name: userModel.name,
          address: userModel.address,
          NIK: userModel.NIK,
          phoneNumber: userModel.phoneNumber,
          dateOfBirth: userModel.dateOfBirth,
          gender: userModel.gender,
          password: userModel.password,
        ),
      );
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUp(
    String email,
    String password,
    String name,
    String phoneNumber,
    String NIK,
    DateTime dateOfBirth,
  ) async {
    try {
      final userModel = await remoteDataSource.signUp(
        email,
        password,
        name,
        NIK,
        phoneNumber,
        dateOfBirth,
      );
      await localDataSource.cacheUser(userModel);

      return Right(
        UserEntity(
          uid: userModel.uid,
          email: userModel.email,
          password: userModel.password,
          name: userModel.name,
          address: userModel.address ?? "",
          phoneNumber: userModel.phoneNumber ?? "",
          NIK: userModel.NIK ?? "",
          dateOfBirth: userModel.dateOfBirth ?? DateTime.now(),
          gender: userModel.gender ?? "",
        ),
      );
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      await localDataSource.clearCachedUser();
      return const Right(null);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCachedUser() async {
    try {
      final hasUser = await localDataSource.hasCachedUser();
      if (!hasUser) return const Right(null);
      final userModel = await localDataSource.getCachedUser();
      return Right(userModel);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, bool>> isSignedIn() async {
    try {
      final result = await localDataSource.hasCachedUser();
      return Right(result);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}
