import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:majadigi/core/error/exceptions.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/core/utils/mapper/failure_mapper.dart';
import 'package:majadigi/core/utils/mapper/firebase_auth_helper.dart';
import 'package:majadigi/features/auth/data/datasources/remote/auth_datasource_remote.dart';
import 'package:majadigi/features/auth/domain/entitiy/user_entity.dart';
import 'package:majadigi/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository{
  final FirebaseAuth firebaseAuth;
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.firebaseAuth, required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> signIn(String email, String password) async {
    try{
      final userModel = await remoteDataSource.signIn(email, password);


      return Right(UserEntity(
        uid: userModel.uid,
        email: userModel.email,
        name: userModel.name,
        address: userModel.address,
        NIK: userModel.NIK,
        phoneNumber: userModel.phoneNumber,
        dateOfBirth: userModel.dateOfBirth,
        gender: userModel.gender,
        password: userModel.password,
      ));

    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } 
  }

  @override
  Future<Either<Failure, UserEntity>> signUp(String email, String password, String name, String phoneNumber, String NIK, DateTime dateOfBirth) async {
    try{
      final userModel = await remoteDataSource.signUp(email, password, name, NIK, phoneNumber, dateOfBirth);

      return Right(UserEntity(
        uid: userModel.uid,
        email: userModel.email,
        password: userModel.password,
        name: userModel.name,
        address: userModel.address ?? "",
        phoneNumber: userModel.phoneNumber ?? "",
        NIK: userModel.NIK ?? "",
        dateOfBirth: userModel.dateOfBirth ?? DateTime.now(),
        gender: userModel.gender ?? "",
      ));

    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() {
    // TODO: implement signInWithGoogle
    throw UnimplementedError();
  }



  @override
  // TODO: implement userSession
  Stream<UserEntity?> get userSession => throw UnimplementedError();


}