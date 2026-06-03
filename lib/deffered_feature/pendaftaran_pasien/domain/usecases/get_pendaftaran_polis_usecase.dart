import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/domain/entity/pendaftaran_poli_entity.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/domain/repositories/pendaftaran_repository.dart';

class GetPendaftaranPolisUseCase {
  final PendaftaranRepository repository;

  GetPendaftaranPolisUseCase(this.repository);

  Future<Either<Failure, List<PendaftaranPoliEntity>>> call(String hospitalId) async {
    return await repository.getPoliList(hospitalId);
  }
}
