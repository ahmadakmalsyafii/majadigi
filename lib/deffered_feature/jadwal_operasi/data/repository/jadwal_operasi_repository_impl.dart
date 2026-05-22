import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/exceptions.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/deffered_feature/jadwal_operasi/data/datasources/jadwal_operasi_remote_datasource.dart';
import 'package:majadigi/deffered_feature/jadwal_operasi/domain/entity/jadwal_operasi_entity.dart';
import 'package:majadigi/deffered_feature/jadwal_operasi/domain/repositories/jadwal_operasi_repository.dart';

class JadwalOperasiRepositoryImpl implements JadwalOperasiRepository {
  final JadwalOperasiRemoteDataSource remoteDataSource;

  JadwalOperasiRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, JadwalOperasiResponseEntity>> getJadwalOperasi({String? date, String? surgeryName}) async {
    try {
      final result = await remoteDataSource.getJadwalOperasi(date: date, surgeryName: surgeryName);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
