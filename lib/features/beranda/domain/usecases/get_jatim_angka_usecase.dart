import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/features/beranda/domain/entity/jatim_angka_entity.dart';
import 'package:majadigi/features/beranda/domain/repositories/jatim_angka_repository.dart';

class GetJatimAngkaUseCase {
  final JatimAngkaRepository repository;

  GetJatimAngkaUseCase(this.repository);

  Future<Either<Failure, List<JatimAngkaEntity>>> call() async {
    return await repository.getJatimAngka();
  }
}
