
import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/features/beranda/data/datasources/remote/banner_remote_datasource.dart';
import 'package:majadigi/features/beranda/domain/entitiy/banner_entity.dart';
import 'package:majadigi/features/beranda/domain/repositories/banner_repository.dart';

class BerandaRepositoryImpl implements BannerRepository{
  final BannerRemoteDataSource remoteDataSource;

  BerandaRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<BannerEntity>>> getBanners() async {
    try {
      final banners = await remoteDataSource.getAllBanners();
      final activeBanners = banners.where((banner) => banner.isActive).toList();
      return Right(activeBanners);
    } on ServerFailure catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

}