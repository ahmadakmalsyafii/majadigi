import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import '../entities/activity_history_entity.dart';

abstract class ActivityHistoryRepository {
  Future<Either<Failure, List<ActivityHistoryEntity>>> getActivityHistories(
    String userId,
  );
  Future<Either<Failure, void>> saveActivityHistory(
    ActivityHistoryEntity activityHistory,
  );
}
