import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/deffered_feature/no_darurat/domain/entity/emergency_number_entity.dart';
import 'package:majadigi/deffered_feature/no_darurat/domain/repositories/emergency_repository.dart';

class GetEmergencyNumbersUseCase {
  final EmergencyRepository repository;

  GetEmergencyNumbersUseCase(this.repository);

  Future<Either<Failure, List<EmergencyNumberEntity>>> call({
    String? kabKotaId,
  }) {
    return repository.getEmergencyNumbers(kabKotaId: kabKotaId);
  }
}
