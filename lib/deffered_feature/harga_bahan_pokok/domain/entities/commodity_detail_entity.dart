import 'package:majadigi/deffered_feature/harga_bahan_pokok/domain/entities/city_price_entity.dart';

class CommodityDetailResponseEntity {
  final CommodityDetailDataEntity data;
  final String message;
  final int statusCode;

  CommodityDetailResponseEntity({
    required this.data,
    required this.message,
    required this.statusCode,
  });
}

class CommodityDetailDataEntity {
  final int bpId;
  final String commodityName;
  final String commodityUnit;
  final int price;
  final int yPrice;
  final int diff;
  final String diffPercent;
  final String icon;
  final String image;
  final CityPriceDetailEntity minCity;
  final CityPriceDetailEntity maxCity;

  CommodityDetailDataEntity({
    required this.bpId,
    required this.commodityName,
    required this.commodityUnit,
    required this.price,
    required this.yPrice,
    required this.diff,
    required this.diffPercent,
    required this.icon,
    required this.image,
    required this.minCity,
    required this.maxCity,
  });
}
