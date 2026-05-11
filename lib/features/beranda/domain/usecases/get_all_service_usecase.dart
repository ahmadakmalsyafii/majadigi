
import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/features/beranda/domain/entitiy/service_entity.dart';
import 'package:majadigi/features/beranda/domain/repositories/service_repository.dart';

class GetAllServiceUsecase {
  final ServiceRepository repository;

  GetAllServiceUsecase(this.repository);

  Future<Either<Failure,List<ServiceEntity>>> call() async {
    return await repository.getAllService();
  }
}