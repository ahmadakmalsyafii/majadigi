import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/exceptions.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/deffered_feature/no_darurat/data/datasources/emergency_remote_datasource.dart';
import 'package:majadigi/deffered_feature/no_darurat/domain/entity/emergency_number_entity.dart';
import 'package:majadigi/deffered_feature/no_darurat/domain/entity/kab_kota_entity.dart';
import 'package:majadigi/deffered_feature/no_darurat/domain/repositories/emergency_repository.dart';

class EmergencyRepositoryImpl implements EmergencyRepository {
  final EmergencyRemoteDataSource remoteDataSource;

  EmergencyRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<EmergencyNumberEntity>>> getEmergencyNumbers({
    String? kabKotaId,
  }) async {
    try {
      final result = await remoteDataSource.getEmergencyNumbers(
        kabKotaId: kabKotaId,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<KabKotaEntity>>> getKabKota() async {
    try {
      final result = await remoteDataSource.getKabKota();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
