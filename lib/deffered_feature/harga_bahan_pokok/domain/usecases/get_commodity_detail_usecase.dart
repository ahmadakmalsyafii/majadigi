import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/domain/entities/commodity_detail_entity.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/domain/repositories/harga_bahan_pokok_repository.dart';

class GetCommodityDetailUseCase {
  final HargaBahanPokokRepository repository;

  GetCommodityDetailUseCase(this.repository);

  Future<Either<Failure, CommodityDetailResponseEntity>> call(int bpId) {
    return repository.getCommodityDetail(bpId);
  }
}
