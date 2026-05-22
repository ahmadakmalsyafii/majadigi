import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/deffered_feature/antrean_pasien/domain/entity/poli_entity.dart';
import 'package:majadigi/deffered_feature/antrean_pasien/domain/repositories/antrean_repository.dart';

class GetPoliUseCase {
  final AntreanRepository repository;

  GetPoliUseCase(this.repository);

  Future<Either<Failure, List<PoliEntity>>> call() async {
    return await repository.getPoliList();
  }
}
