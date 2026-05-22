import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/deffered_feature/jadwal_operasi/domain/entity/jadwal_operasi_entity.dart';
import 'package:majadigi/deffered_feature/jadwal_operasi/domain/repositories/jadwal_operasi_repository.dart';

class GetJadwalOperasiUseCase {
  final JadwalOperasiRepository repository;

  GetJadwalOperasiUseCase(this.repository);

  Future<Either<Failure, JadwalOperasiResponseEntity>> call({String? date, String? surgeryName}) async {
    return await repository.getJadwalOperasi(date: date, surgeryName: surgeryName);
  }
}
