import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/features/layanan/domain/entities/layanan_entity.dart';

abstract class LayananRepository {
  Future<Either<Failure, List<LayananEntity>>> getKatalogLayanan();
}
