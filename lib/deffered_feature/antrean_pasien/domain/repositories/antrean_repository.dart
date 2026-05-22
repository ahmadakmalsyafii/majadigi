import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/deffered_feature/antrean_pasien/domain/entity/antrean_entity.dart';
import 'package:majadigi/deffered_feature/antrean_pasien/domain/entity/dokter_entity.dart';
import 'package:majadigi/deffered_feature/antrean_pasien/domain/entity/poli_entity.dart';

abstract class AntreanRepository {
  Future<Either<Failure, List<PoliEntity>>> getPoliList();
  Future<Either<Failure, List<DokterEntity>>> getDokterList(String poliId);
  Future<Either<Failure, AntreanEntity>> getAntreanStatus(String poliId, String doctorId);
}
