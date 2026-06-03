import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/domain/entity/pendaftaran_poli_entity.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/domain/entity/pendaftaran_dokter_entity.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/domain/entity/pendaftaran_booking_entity.dart';

abstract class PendaftaranRepository {
  Future<Either<Failure, List<PendaftaranPoliEntity>>> getPoliList(String hospitalId);
  Future<Either<Failure, List<PendaftaranDokterEntity>>> getDokterList(String hospitalId, String poliId);
  Future<Either<Failure, Map<String, int>>> getTimeSlotQuotas(String doctorId, String date);
  Future<Either<Failure, PendaftaranBookingEntity>> saveRegistration(PendaftaranBookingEntity booking);
}
