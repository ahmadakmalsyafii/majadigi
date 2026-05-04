

import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/features/beranda/domain/entitiy/banner_entity.dart';

abstract class BannerRepository {
  Future<Either<Failure, List<BannerEntity>>> getBanners();
}