
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/features/beranda/domain/entity/service_entity.dart';
import 'package:majadigi/features/beranda/domain/repositories/service_repository.dart';

class GetServiceSectionUsecase {
  final ServiceRepository repository;

  GetServiceSectionUsecase(this.repository);

  Future<Either<Failure, List<ServiceEntity>>> call() async {
    return await repository.getServiceSection();
  }
}