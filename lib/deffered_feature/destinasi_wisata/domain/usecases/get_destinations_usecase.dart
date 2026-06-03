import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/deffered_feature/destinasi_wisata/domain/entity/destination_entity.dart';
import 'package:majadigi/deffered_feature/destinasi_wisata/domain/repositories/destination_repository.dart';

class GetDestinationsUseCase {
  final DestinationRepository repository;

  GetDestinationsUseCase(this.repository);

  Future<Either<Failure, List<DestinationEntity>>> call() async {
    return await repository.getDestinations();
  }
}
