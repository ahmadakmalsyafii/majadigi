import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/deffered_feature/no_darurat/domain/entity/emergency_number_entity.dart';
import 'package:majadigi/deffered_feature/no_darurat/domain/entity/kab_kota_entity.dart';

abstract class EmergencyRepository {
  Future<Either<Failure, List<EmergencyNumberEntity>>> getEmergencyNumbers({
    String? kabKotaId,
  });

  Future<Either<Failure, List<KabKotaEntity>>> getKabKota();
}
