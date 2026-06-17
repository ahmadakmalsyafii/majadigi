import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import '../entities/activity_history_entity.dart';
import '../repositories/activity_history_repository.dart';

class SaveActivityHistoryUseCase {
  final ActivityHistoryRepository repository;

  SaveActivityHistoryUseCase(this.repository);

  Future<Either<Failure, void>> execute(
    ActivityHistoryEntity activityHistory,
  ) async {
    return await repository.saveActivityHistory(activityHistory);
  }
}
