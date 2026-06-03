import 'package:majadigi/deffered_feature/harga_bahan_pokok/domain/entities/commodity_detail_entity.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/data/models/city_price_model.dart';

class CommodityDetailResponse extends CommodityDetailResponseEntity {
  CommodityDetailResponse({
    required super.data,
    required super.message,
    required super.statusCode,
  });

  factory CommodityDetailResponse.fromJson(Map<String, dynamic> json) {
    return CommodityDetailResponse(
      data: CommodityDetailData.fromJson(json['data'] ?? {}),
      message: json['message'] ?? '',
      statusCode: json['statusCode'] ?? 200,
    );
  }
}

class CommodityDetailData extends CommodityDetailDataEntity {
  CommodityDetailData({
    required super.bpId,
    required super.commodityName,
    required super.commodityUnit,
    required super.price,
    required super.yPrice,
    required super.diff,
    required super.diffPercent,
    required super.icon,
    required super.image,
    required super.minCity,
    required super.maxCity,
  });

  factory CommodityDetailData.fromJson(Map<String, dynamic> json) {
    return CommodityDetailData(
      bpId: json['bp_id'] ?? 0,
      commodityName: json['commodity_name'] ?? '',
      commodityUnit: json['commodity_unit'] ?? '',
      price: json['price'] ?? 0,
      yPrice: json['y_price'] ?? 0,
      diff: json['diff'] ?? 0,
      diffPercent: json['diff_percent'] ?? '',
      icon: json['icon'] ?? '',
      image: json['image'] ?? '',
      minCity: CityPriceDetailModel.fromJson(json['min_city'] ?? {}),
      maxCity: CityPriceDetailModel.fromJson(json['max_city'] ?? {}),
    );
  }
}
