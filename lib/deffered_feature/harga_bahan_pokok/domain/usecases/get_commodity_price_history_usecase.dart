import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/domain/entities/commodity_price_history_entity.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/domain/repositories/harga_bahan_pokok_repository.dart';

@injectable
class GetCommodityPriceHistoryUseCase {
  final HargaBahanPokokRepository repository;

  GetCommodityPriceHistoryUseCase(this.repository);

  Future<Either<Failure, CommodityPriceHistoryEntity>> call(int bpId) async {
    return await repository.getCommodityPriceHistory(bpId);
  }
}
