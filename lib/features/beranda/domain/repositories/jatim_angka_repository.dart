import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/features/beranda/domain/entity/jatim_angka_entity.dart';

abstract class JatimAngkaRepository {
  Future<Either<Failure, List<JatimAngkaEntity>>> getJatimAngka();
}
