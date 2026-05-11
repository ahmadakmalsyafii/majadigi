
import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/features/beranda/data/datasources/remote/beranda_remote_datasource.dart';
import 'package:majadigi/features/beranda/domain/entitiy/banner_entity.dart';
import 'package:majadigi/features/beranda/domain/entitiy/service_entity.dart';
import 'package:majadigi/features/beranda/domain/entitiy/jatim_angka_entity.dart';
import 'package:majadigi/features/beranda/domain/repositories/banner_repository.dart';
import 'package:majadigi/features/beranda/domain/repositories/service_repository.dart';
import 'package:majadigi/features/beranda/domain/repositories/jatim_angka_repository.dart';

class BerandaRepositoryImpl implements BannerRepository, ServiceRepository, JatimAngkaRepository{
  final BerandaRemoteDatasource remoteDataSource;

  BerandaRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<BannerEntity>>> getBanners() async {
    try {
      final banners = await remoteDataSource.getAllBanner();
      final activeBanners = banners.where((banner) => banner.isActive).toList();
      return Right(activeBanners);
    } on ServerFailure catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ServiceEntity>>> getAllService() async {
    try {
      final services = await remoteDataSource.getAllService();
      return Right(services);
    } on ServerFailure catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<JatimAngkaEntity>>> getJatimAngka() async {
    try {
      final jatimAngka = await remoteDataSource.getJatimAngka();
      return Right(jatimAngka);
    } on ServerFailure catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}