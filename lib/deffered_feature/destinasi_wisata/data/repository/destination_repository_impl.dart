import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/exceptions.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/deffered_feature/destinasi_wisata/data/datasources/destination_remote_datasource.dart';
import 'package:majadigi/deffered_feature/destinasi_wisata/domain/entity/destination_entity.dart';
import 'package:majadigi/deffered_feature/destinasi_wisata/domain/repositories/destination_repository.dart';

class DestinationRepositoryImpl implements DestinationRepository {
  final DestinationRemoteDataSource remoteDataSource;

  DestinationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<DestinationEntity>>> getDestinations() async {
    try {
      final result = await remoteDataSource.getDestinations();
      return Right(result);
    } on ServerException {
      return const Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
