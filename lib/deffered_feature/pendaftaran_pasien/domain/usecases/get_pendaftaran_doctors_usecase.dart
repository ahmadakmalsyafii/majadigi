import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/domain/entity/pendaftaran_dokter_entity.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/domain/repositories/pendaftaran_repository.dart';

class GetPendaftaranDoctorsUseCase {
  final PendaftaranRepository repository;

  GetPendaftaranDoctorsUseCase(this.repository);

  Future<Either<Failure, List<PendaftaranDokterEntity>>> call(String hospitalId, String poliId) async {
    return await repository.getDokterList(hospitalId, poliId);
  }
}
