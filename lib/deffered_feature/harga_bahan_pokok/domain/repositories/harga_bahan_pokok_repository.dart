import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/domain/entities/commodity_entity.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/domain/entities/commodity_detail_entity.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/domain/entities/city_price_entity.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/domain/entities/commodity_price_history_entity.dart';

abstract class HargaBahanPokokRepository {
  Future<Either<Failure, CommodityResponseEntity>> getCommodityPriceList({int page = 1, int limit = 999});
  Future<Either<Failure, CommodityDetailResponseEntity>> getCommodityDetail(int bpId);
  Future<Either<Failure, CityPriceResponseEntity>> getCityPriceList(int bpId, {int page = 1, int limit = 99999});
  Future<Either<Failure, CommodityPriceHistoryEntity>> getCommodityPriceHistory(int bpId);
}
