import 'package:majadigi/core/network/dio_client.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/data/models/commodity_model.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/data/models/commodity_detail_model.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/data/models/city_price_model.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/data/models/commodity_price_history_model.dart';

abstract class HargaBahanPokokRemoteDataSource {
  Future<CommodityResponse> getCommodityPriceList({int page = 1, int limit = 999});
  Future<CommodityDetailResponse> getCommodityDetail(int bpId);
  Future<CityPriceResponse> getCityPriceList(int bpId, {int page = 1, int limit = 99999, String sort = '-avg_price'});
  Future<CommodityPriceHistoryModel> getCommodityPriceHistory(int bpId);
}

class HargaBahanPokokRemoteDataSourceImpl implements HargaBahanPokokRemoteDataSource {
  final DioClient dioClient;

  HargaBahanPokokRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<CommodityResponse> getCommodityPriceList({int page = 1, int limit = 999}) async {
    try {
      final response = await dioClient.dio.get(
        '/t/jatimprov.go.id/kominfo/transformer/v1/disperindag/commodity/price',
        queryParameters: {
          'page': page,
          'limit': limit,
          'sort': 'name',
        },
      );
      return CommodityResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CommodityDetailResponse> getCommodityDetail(int bpId) async {
    try {
      final response = await dioClient.dio.get(
        '/t/jatimprov.go.id/kominfo/transformer/v1/disperindag/commodity/$bpId',
      );
      return CommodityDetailResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CityPriceResponse> getCityPriceList(int bpId, {int page = 1, int limit = 99999, String sort = '-avg_price'}) async {
    try {
      final response = await dioClient.dio.get(
        '/t/jatimprov.go.id/kominfo/transformer/v1/disperindag/commodity/$bpId/price/city',
        queryParameters: {
          'page': page,
          'limit': limit,
          'sort': sort,
        },
      );
      return CityPriceResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CommodityPriceHistoryModel> getCommodityPriceHistory(int bpId) async {
    try {
      final response = await dioClient.dio.get(
        '/t/jatimprov.go.id/kominfo/transformer/v1/disperindag/commodity/$bpId/price/30-days',
      );
      return CommodityPriceHistoryModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
