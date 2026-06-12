import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/data/datasources/harga_bahan_pokok_remote_data_source.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/domain/entities/commodity_entity.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/domain/entities/commodity_detail_entity.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/domain/entities/city_price_entity.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/domain/entities/commodity_price_history_entity.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/domain/repositories/harga_bahan_pokok_repository.dart';

class HargaBahanPokokRepositoryImpl implements HargaBahanPokokRepository {
  final HargaBahanPokokRemoteDataSource remoteDataSource;

  HargaBahanPokokRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, CommodityResponseEntity>> getCommodityPriceList({
    int page = 1,
    int limit = 999,
  }) async {
    try {
      final response = await remoteDataSource.getCommodityPriceList(
        page: page,
        limit: limit,
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server Error'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CommodityDetailResponseEntity>> getCommodityDetail(
    int bpId,
  ) async {
    try {
      final response = await remoteDataSource.getCommodityDetail(bpId);
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server Error'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CityPriceResponseEntity>> getCityPriceList(
    int bpId, {
    int page = 1,
    int limit = 99999,
  }) async {
    try {
      final response = await remoteDataSource.getCityPriceList(
        bpId,
        page: page,
        limit: limit,
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server Error'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CommodityPriceHistoryEntity>> getCommodityPriceHistory(
    int bpId,
  ) async {
    try {
      final result = await remoteDataSource.getCommodityPriceHistory(bpId);
      final entity = CommodityPriceHistoryEntity(
        data: result.data
            .map(
              (item) =>
                  PriceHistoryItemEntity(date: item.date, price: item.price),
            )
            .toList(),
      );
      return Right(entity);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server Error'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
