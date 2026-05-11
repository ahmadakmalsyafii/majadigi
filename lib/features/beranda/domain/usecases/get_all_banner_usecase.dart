
import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/features/beranda/domain/entitiy/banner_entity.dart';
import 'package:majadigi/features/beranda/domain/repositories/banner_repository.dart';

class GetAllBannerUseCase {

  final BannerRepository repository;

  GetAllBannerUseCase(this.repository);
  Future<Either<Failure, List<BannerEntity>>> call() async {
    return await repository.getBanners();
  }
}