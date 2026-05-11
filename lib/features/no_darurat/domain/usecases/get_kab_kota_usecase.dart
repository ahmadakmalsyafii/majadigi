import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/features/no_darurat/domain/entity/kab_kota_entity.dart';
import 'package:majadigi/features/no_darurat/domain/repositories/emergency_repository.dart';

class GetKabKotaUseCase {
  final EmergencyRepository repository;

  GetKabKotaUseCase(this.repository);

  Future<Either<Failure, List<KabKotaEntity>>> call() {
    return repository.getKabKota();
  }
}
