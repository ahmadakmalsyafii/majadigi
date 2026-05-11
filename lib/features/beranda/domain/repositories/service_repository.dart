
import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/features/beranda/domain/entitiy/service_entity.dart';

abstract class ServiceRepository {
  Future<Either<Failure,List<ServiceEntity>>> getAllService();
}