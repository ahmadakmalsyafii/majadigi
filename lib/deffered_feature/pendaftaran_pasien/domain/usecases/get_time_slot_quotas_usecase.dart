import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/domain/repositories/pendaftaran_repository.dart';

class GetTimeSlotQuotasUseCase {
  final PendaftaranRepository repository;

  GetTimeSlotQuotasUseCase(this.repository);

  Future<Either<Failure, Map<String, int>>> call(String doctorId, String date) async {
    return await repository.getTimeSlotQuotas(doctorId, date);
  }
}
