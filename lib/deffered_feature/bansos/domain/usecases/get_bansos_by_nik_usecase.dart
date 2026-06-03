import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/deffered_feature/bansos/domain/entity/bansos_entity.dart';
import 'package:majadigi/deffered_feature/bansos/domain/repositories/bansos_repository.dart';

class GetBansosByNikUseCase {
  final BansosRepository repository;

  GetBansosByNikUseCase(this.repository);

  Future<Either<Failure, BansosEntity?>> call(String nik) async {
    return await repository.getBansosByNik(nik);
  }
}
