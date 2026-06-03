import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/deffered_feature/islamic_center/domain/entity/facility_entity.dart';

abstract class IslamicCenterRepository {
  Future<Either<Failure, List<FacilityEntity>>> getFacilities();
}
