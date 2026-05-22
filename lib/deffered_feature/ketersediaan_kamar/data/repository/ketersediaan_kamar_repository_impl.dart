import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/exceptions.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/deffered_feature/ketersediaan_kamar/data/datasources/ketersediaan_kamar_remote_datasource.dart';
import 'package:majadigi/deffered_feature/ketersediaan_kamar/domain/entity/room_availability_entity.dart';
import 'package:majadigi/deffered_feature/ketersediaan_kamar/domain/repositories/ketersediaan_kamar_repository.dart';

class KetersediaanKamarRepositoryImpl implements KetersediaanKamarRepository {
  final KetersediaanKamarRemoteDataSource remoteDataSource;

  KetersediaanKamarRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, RoomAvailabilityEntity>> getRoomAvailability(String hospitalName) async {
    try {
      final result = await remoteDataSource.getRoomAvailability(hospitalName);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
