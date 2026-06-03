class CityPriceResponseEntity {
  final List<CityPriceEntity> data;
  final int page;
  final int total;
  final int perPage;
  final String message;
  final int statusCode;

  CityPriceResponseEntity({
    required this.data,
    required this.page,
    required this.total,
    required this.perPage,
    required this.message,
    required this.statusCode,
  });
}

class CityPriceEntity {
  final int kabkotaId;
  final String kabkotaName;
  final int totalMarket;
  final int totalPrice;
  final int avgPrice;

  CityPriceEntity({
    required this.kabkotaId,
    required this.kabkotaName,
    required this.totalMarket,
    required this.totalPrice,
    required this.avgPrice,
  });
}

class CityPriceDetailEntity {
  final int kabkotaId;
  final String kabkotaName;
  final int totalMarket;
  final int totalPrice;
  final int avgPrice;

  CityPriceDetailEntity({
    required this.kabkotaId,
    required this.kabkotaName,
    required this.totalMarket,
    required this.totalPrice,
    required this.avgPrice,
  });
}
