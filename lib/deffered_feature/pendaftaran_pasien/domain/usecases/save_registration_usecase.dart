import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/domain/entity/pendaftaran_booking_entity.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/domain/repositories/pendaftaran_repository.dart';

class SaveRegistrationUseCase {
  final PendaftaranRepository repository;

  SaveRegistrationUseCase(this.repository);

  Future<Either<Failure, PendaftaranBookingEntity>> call(PendaftaranBookingEntity booking) async {
    return await repository.saveRegistration(booking);
  }
}
