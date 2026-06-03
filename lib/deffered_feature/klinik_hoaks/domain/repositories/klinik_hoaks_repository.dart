import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/deffered_feature/klinik_hoaks/domain/entity/klinik_hoaks_stats_entity.dart';
import 'package:majadigi/deffered_feature/klinik_hoaks/domain/entity/klinik_hoaks_clarification_entity.dart';

abstract class KlinikHoaksRepository {
  Future<Either<Failure, KlinikHoaksStatsEntity>> getStats();
  Future<Either<Failure, List<KlinikHoaksClarificationEntity>>> getClarifications();
  Future<Either<Failure, bool>> reportHoax({
    required String info,
    required String source,
    String? filePath,
  });
}
