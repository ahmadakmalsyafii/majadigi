import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/core/error/exceptions.dart';
import 'package:majadigi/deffered_feature/bansos/data/datasources/bansos_remote_datasource.dart';
import 'package:majadigi/deffered_feature/bansos/domain/entity/bansos_entity.dart';
import 'package:majadigi/deffered_feature/bansos/domain/repositories/bansos_repository.dart';

class BansosRepositoryImpl implements BansosRepository {
  final BansosRemoteDataSource remoteDataSource;

  BansosRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, BansosEntity?>> getBansosByNik(String nik) async {
    try {
      final result = await remoteDataSource.getBansosByNik(nik);
      if (result != null) {
        return Right(result.toEntity());
      }
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error occurred'));
    }
  }
}
