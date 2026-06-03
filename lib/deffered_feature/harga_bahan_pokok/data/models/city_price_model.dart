import 'package:majadigi/deffered_feature/harga_bahan_pokok/domain/entities/city_price_entity.dart';

class CityPriceResponse extends CityPriceResponseEntity {
  CityPriceResponse({
    required super.data,
    required super.page,
    required super.total,
    required super.perPage,
    required super.message,
    required super.statusCode,
  });

  factory CityPriceResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List? ?? [];
    List<CityPriceModel> dataList = list.map((i) => CityPriceModel.fromJson(i)).toList();
    return CityPriceResponse(
      data: dataList,
      page: json['page'] ?? 1,
      total: json['total'] ?? 0,
      perPage: json['perPage'] ?? 99999,
      message: json['message'] ?? '',
      statusCode: json['statusCode'] ?? 200,
    );
  }
}

class CityPriceModel extends CityPriceEntity {
  CityPriceModel({
    required super.kabkotaId,
    required super.kabkotaName,
    required super.totalMarket,
    required super.totalPrice,
    required super.avgPrice,
  });

  factory CityPriceModel.fromJson(Map<String, dynamic> json) {
    return CityPriceModel(
      kabkotaId: json['kabkota_id'] ?? 0,
      kabkotaName: json['kabkota_name'] ?? '-',
      totalMarket: json['total_market'] ?? 0,
      totalPrice: json['total_price'] ?? 0,
      avgPrice: json['avg_price'] ?? 0,
    );
  }
}

class CityPriceDetailModel extends CityPriceDetailEntity {
  CityPriceDetailModel({
    required super.kabkotaId,
    required super.kabkotaName,
    required super.totalMarket,
    required super.totalPrice,
    required super.avgPrice,
  });

  factory CityPriceDetailModel.fromJson(Map<String, dynamic> json) {
    return CityPriceDetailModel(
      kabkotaId: json['kabkota_id'] ?? 0,
      kabkotaName: json['kabkota_name'] ?? '-',
      totalMarket: json['total_market'] ?? 0,
      totalPrice: json['total_price'] ?? 0,
      avgPrice: json['avg_price'] ?? 0,
    );
  }
}
