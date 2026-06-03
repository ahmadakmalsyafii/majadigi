import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/deffered_feature/islamic_center/data/datasources/islamic_center_remote_datasource.dart';
import 'package:majadigi/deffered_feature/islamic_center/domain/entity/facility_entity.dart';
import 'package:majadigi/deffered_feature/islamic_center/domain/repositories/islamic_center_repository.dart';

class IslamicCenterRepositoryImpl implements IslamicCenterRepository {
  final IslamicCenterRemoteDataSource remoteDataSource;

  IslamicCenterRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<FacilityEntity>>> getFacilities() async {
    try {
      final facilities = await remoteDataSource.getFacilities();
      return Right(facilities);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
