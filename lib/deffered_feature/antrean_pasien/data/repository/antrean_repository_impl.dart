import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/exceptions.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/deffered_feature/antrean_pasien/data/datasources/antrean_remote_datasource.dart';
import 'package:majadigi/deffered_feature/antrean_pasien/domain/entity/antrean_entity.dart';
import 'package:majadigi/deffered_feature/antrean_pasien/domain/entity/dokter_entity.dart';
import 'package:majadigi/deffered_feature/antrean_pasien/domain/entity/poli_entity.dart';
import 'package:majadigi/deffered_feature/antrean_pasien/domain/repositories/antrean_repository.dart';

class AntreanRepositoryImpl implements AntreanRepository {
  final AntreanRemoteDataSource remoteDataSource;

  AntreanRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<PoliEntity>>> getPoliList() async {
    try {
      final result = await remoteDataSource.getPoliList();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DokterEntity>>> getDokterList(String poliId) async {
    try {
      final result = await remoteDataSource.getDokterList(poliId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AntreanEntity>> getAntreanStatus(String poliId, String doctorId) async {
    try {
      final result = await remoteDataSource.getAntreanStatus(poliId, doctorId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
