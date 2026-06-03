import 'package:majadigi/deffered_feature/harga_bahan_pokok/domain/entities/commodity_entity.dart';

class CommodityResponse extends CommodityResponseEntity {
  CommodityResponse({
    required super.data,
    required super.page,
    required super.total,
    required super.perPage,
    required super.message,
    required super.statusCode,
  });

  factory CommodityResponse.fromJson(Map<String, dynamic> json) {
    return CommodityResponse(
      data: CommodityData.fromJson(json['data'] ?? {}),
      page: json['page'] ?? 1,
      total: json['total'] ?? 0,
      perPage: json['perPage'] ?? 12,
      message: json['message'] ?? '',
      statusCode: json['statusCode'] ?? 200,
    );
  }
}

class CommodityData extends CommodityDataEntity {
  CommodityData({required super.priceList});

  factory CommodityData.fromJson(Map<String, dynamic> json) {
    var list = json['priceList'] as List? ?? [];
    List<CommodityItem> priceList = list.map((i) => CommodityItem.fromJson(i)).toList();
    return CommodityData(priceList: priceList);
  }
}

class CommodityItem extends CommodityItemEntity {
  CommodityItem({
    required super.bpId,
    required super.commodityName,
    required super.commodityUnit,
    required super.price,
    required super.yPrice,
    required super.diff,
    required super.diffPercent,
    required super.icon,
    required super.image,
  });

  factory CommodityItem.fromJson(Map<String, dynamic> json) {
    return CommodityItem(
      bpId: json['bp_id'] ?? 0,
      commodityName: json['commodity_name'] ?? '',
      commodityUnit: json['commodity_unit'] ?? '',
      price: json['price'] ?? 0,
      yPrice: json['y_price'] ?? 0,
      diff: json['diff'] ?? 0,
      diffPercent: json['diff_percent'] ?? '',
      icon: json['icon'] ?? '',
      image: json['image'] ?? '',
    );
  }
}
