import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/domain/entities/commodity_entity.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/domain/repositories/harga_bahan_pokok_repository.dart';

class GetCommodityPriceListUseCase {
  final HargaBahanPokokRepository repository;

  GetCommodityPriceListUseCase(this.repository);

  Future<Either<Failure, CommodityResponseEntity>> call({int page = 1, int limit = 999}) {
    return repository.getCommodityPriceList(page: page, limit: limit);
  }
}
