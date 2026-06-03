import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/deffered_feature/islamic_center/domain/entity/facility_entity.dart';
import 'package:majadigi/deffered_feature/islamic_center/domain/repositories/islamic_center_repository.dart';

class GetFacilitiesUseCase {
  final IslamicCenterRepository repository;

  GetFacilitiesUseCase(this.repository);

  Future<Either<Failure, List<FacilityEntity>>> call() {
    return repository.getFacilities();
  }
}
