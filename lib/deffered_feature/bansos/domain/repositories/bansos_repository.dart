import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/deffered_feature/bansos/domain/entity/bansos_entity.dart';

abstract class BansosRepository {
  Future<Either<Failure, BansosEntity?>> getBansosByNik(String nik);
}
