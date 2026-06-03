import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/deffered_feature/klinik_hoaks/domain/entity/klinik_hoaks_stats_entity.dart';
import 'package:majadigi/deffered_feature/klinik_hoaks/domain/repositories/klinik_hoaks_repository.dart';

class GetKlinikHoaksStatsUseCase {
  final KlinikHoaksRepository repository;

  GetKlinikHoaksStatsUseCase({required this.repository});

  Future<Either<Failure, KlinikHoaksStatsEntity>> call() async {
    return await repository.getStats();
  }
}
