import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/exceptions.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/data/datasources/pendaftaran_remote_datasource.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/data/model/pendaftaran_booking_model.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/domain/entity/pendaftaran_poli_entity.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/domain/entity/pendaftaran_dokter_entity.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/domain/entity/pendaftaran_booking_entity.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/domain/repositories/pendaftaran_repository.dart';

class PendaftaranRepositoryImpl implements PendaftaranRepository {
  final PendaftaranRemoteDataSource remoteDataSource;

  PendaftaranRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<PendaftaranPoliEntity>>> getPoliList(String hospitalId) async {
    try {
      final polis = await remoteDataSource.getPoliList(hospitalId);
      return Right(polis);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Terjadi kesalahan sistem: $e'));
    }
  }

  @override
  Future<Either<Failure, List<PendaftaranDokterEntity>>> getDokterList(String hospitalId, String poliId) async {
    try {
      final doctors = await remoteDataSource.getDokterList(hospitalId, poliId);
      return Right(doctors);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Terjadi kesalahan sistem: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, int>>> getTimeSlotQuotas(String doctorId, String date) async {
    try {
      final quotas = await remoteDataSource.getTimeSlotQuotas(doctorId, date);
      return Right(quotas);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Terjadi kesalahan sistem: $e'));
    }
  }

  @override
  Future<Either<Failure, PendaftaranBookingEntity>> saveRegistration(PendaftaranBookingEntity booking) async {
    try {
      final bookingModel = PendaftaranBookingModel(
        id: booking.id,
        userId: booking.userId,
        patientName: booking.patientName,
        patientNIK: booking.patientNIK,
        hospitalId: booking.hospitalId,
        hospitalName: booking.hospitalName,
        poliId: booking.poliId,
        poliName: booking.poliName,
        doctorId: booking.doctorId,
        doctorName: booking.doctorName,
        date: booking.date,
        time: booking.time,
        queueNumber: booking.queueNumber,
        createdAt: booking.createdAt,
      );
      final savedBooking = await remoteDataSource.saveRegistration(bookingModel);
      return Right(savedBooking);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Terjadi kesalahan sistem: $e'));
    }
  }
}
