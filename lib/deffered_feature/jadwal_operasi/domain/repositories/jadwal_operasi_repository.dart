import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/deffered_feature/jadwal_operasi/domain/entity/jadwal_operasi_entity.dart';

abstract class JadwalOperasiRepository {
  Future<Either<Failure, JadwalOperasiResponseEntity>> getJadwalOperasi({
    String? date,
    String? surgeryName,
  });
}
