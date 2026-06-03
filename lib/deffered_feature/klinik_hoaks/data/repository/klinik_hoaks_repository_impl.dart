import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/exceptions.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/deffered_feature/klinik_hoaks/data/datasources/klinik_hoaks_remote_datasource.dart';
import 'package:majadigi/deffered_feature/klinik_hoaks/domain/entity/klinik_hoaks_stats_entity.dart';
import 'package:majadigi/deffered_feature/klinik_hoaks/domain/entity/klinik_hoaks_clarification_entity.dart';
import 'package:majadigi/deffered_feature/klinik_hoaks/domain/repositories/klinik_hoaks_repository.dart';

class KlinikHoaksRepositoryImpl implements KlinikHoaksRepository {
  final KlinikHoaksRemoteDataSource remoteDataSource;

  KlinikHoaksRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, KlinikHoaksStatsEntity>> getStats() async {
    try {
      final stats = await remoteDataSource.getStats();
      return Right(stats);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<KlinikHoaksClarificationEntity>>> getClarifications() async {
    try {
      final clarifications = await remoteDataSource.getClarifications();
      return Right(clarifications);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> reportHoax({
    required String info,
    required String source,
    String? filePath,
  }) async {
    try {
      final result = await remoteDataSource.reportHoax(
        info: info,
        source: source,
        filePath: filePath,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
