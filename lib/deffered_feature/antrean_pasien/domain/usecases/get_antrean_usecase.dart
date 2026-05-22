import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/deffered_feature/antrean_pasien/domain/entity/antrean_entity.dart';
import 'package:majadigi/deffered_feature/antrean_pasien/domain/repositories/antrean_repository.dart';

class GetAntreanUseCase {
  final AntreanRepository repository;

  GetAntreanUseCase(this.repository);

  Future<Either<Failure, AntreanEntity>> call(String poliId, String doctorId) async {
    return await repository.getAntreanStatus(poliId, doctorId);
  }
}
