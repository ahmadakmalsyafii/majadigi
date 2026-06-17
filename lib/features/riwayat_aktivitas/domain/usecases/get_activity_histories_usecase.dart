import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:majadigi/core/error/failure.dart';
import '../entities/activity_history_entity.dart';
import '../repositories/activity_history_repository.dart';

@lazySingleton
class GetActivityHistoriesUseCase {
  final ActivityHistoryRepository repository;

  GetActivityHistoriesUseCase(this.repository);

  Future<Either<Failure, List<ActivityHistoryEntity>>> execute(
    String userId,
  ) async {
    return await repository.getActivityHistories(userId);
  }
}
