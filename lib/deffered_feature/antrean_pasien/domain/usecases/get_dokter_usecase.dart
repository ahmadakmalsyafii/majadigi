import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/deffered_feature/antrean_pasien/domain/entity/dokter_entity.dart';
import 'package:majadigi/deffered_feature/antrean_pasien/domain/repositories/antrean_repository.dart';

class GetDokterUseCase {
  final AntreanRepository repository;

  GetDokterUseCase(this.repository);

  Future<Either<Failure, List<DokterEntity>>> call(String poliId) async {
    return await repository.getDokterList(poliId);
  }
}
