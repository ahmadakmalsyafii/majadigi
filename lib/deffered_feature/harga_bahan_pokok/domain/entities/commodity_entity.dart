class CommodityResponseEntity {
  final CommodityDataEntity data;
  final int page;
  final int total;
  final int perPage;
  final String message;
  final int statusCode;

  CommodityResponseEntity({
    required this.data,
    required this.page,
    required this.total,
    required this.perPage,
    required this.message,
    required this.statusCode,
  });
}

class CommodityDataEntity {
  final List<CommodityItemEntity> priceList;

  CommodityDataEntity({required this.priceList});
}

class CommodityItemEntity {
  final int bpId;
  final String commodityName;
  final String commodityUnit;
  final int price;
  final int yPrice;
  final int diff;
  final String diffPercent;
  final String icon;
  final String image;

  CommodityItemEntity({
    required this.bpId,
    required this.commodityName,
    required this.commodityUnit,
    required this.price,
    required this.yPrice,
    required this.diff,
    required this.diffPercent,
    required this.icon,
    required this.image,
  });
}
