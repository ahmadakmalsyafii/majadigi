import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:majadigi/core/error/exceptions.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/features/layanan/data/datasources/layanan_remote_datasource.dart';
import 'package:majadigi/features/layanan/domain/entities/layanan_entity.dart';
import 'package:majadigi/features/layanan/domain/repositories/layanan_repository.dart';

@LazySingleton(as: LayananRepository)
class LayananRepositoryImpl implements LayananRepository {
  final LayananRemoteDataSource remoteDataSource;

  LayananRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<LayananEntity>>> getKatalogLayanan() async {
    try {
      final result = await remoteDataSource.getKatalogLayanan();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
