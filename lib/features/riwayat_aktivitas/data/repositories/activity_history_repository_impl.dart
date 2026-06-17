import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:majadigi/core/error/failure.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/activity_history_entity.dart';
import '../../domain/repositories/activity_history_repository.dart';
import '../datasources/activity_history_remote_datasource.dart';
import '../models/activity_history_model.dart';

@LazySingleton(as: ActivityHistoryRepository)
class ActivityHistoryRepositoryImpl implements ActivityHistoryRepository {
  final ActivityHistoryRemoteDataSource remoteDataSource;

  ActivityHistoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ActivityHistoryEntity>>> getActivityHistories(
    String userId,
  ) async {
    try {
      final remoteData = await remoteDataSource.getActivityHistories(userId);
      return Right(remoteData);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> saveActivityHistory(
    ActivityHistoryEntity activityHistory,
  ) async {
    try {
      final model = ActivityHistoryModel.fromEntity(activityHistory);
      await remoteDataSource.saveActivityHistory(model);
      return const Right(null);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
