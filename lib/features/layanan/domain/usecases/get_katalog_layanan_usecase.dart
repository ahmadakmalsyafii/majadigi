import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/features/layanan/domain/entities/layanan_entity.dart';
import 'package:majadigi/features/layanan/domain/repositories/layanan_repository.dart';

@lazySingleton
class GetKatalogLayananUseCase {
  final LayananRepository repository;

  GetKatalogLayananUseCase(this.repository);

  Future<Either<Failure, List<LayananEntity>>> call() {
    return repository.getKatalogLayanan();
  }
}
