import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/domain/entities/city_price_entity.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/domain/repositories/harga_bahan_pokok_repository.dart';

class GetCityPriceListUseCase {
  final HargaBahanPokokRepository repository;

  GetCityPriceListUseCase(this.repository);

  Future<Either<Failure, CityPriceResponseEntity>> call(int bpId, {int page = 1, int limit = 99999}) {
    return repository.getCityPriceList(bpId, page: page, limit: limit);
  }
}
