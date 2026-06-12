import 'package:equatable/equatable.dart';

class CommodityPriceHistoryModel extends Equatable {
  final List<PriceHistoryItemModel> data;
  final int page;
  final int total;
  final int perPage;
  final int nextPage;
  final int previousPage;
  final int lastPage;
  final String message;
  final int statusCode;

  const CommodityPriceHistoryModel({
    required this.data,
    required this.page,
    required this.total,
    required this.perPage,
    required this.nextPage,
    required this.previousPage,
    required this.lastPage,
    required this.message,
    required this.statusCode,
  });

  factory CommodityPriceHistoryModel.fromJson(Map<String, dynamic> json) {
    return CommodityPriceHistoryModel(
      data: (json['data'] as List)
          .map((item) => PriceHistoryItemModel.fromJson(item))
          .toList(),
      page: json['page'] ?? 0,
      total: json['total'] ?? 0,
      perPage: json['perPage'] ?? 0,
      nextPage: json['nextPage'] ?? 0,
      previousPage: json['previousPage'] ?? 0,
      lastPage: json['lastPage'] ?? 0,
      message: json['message'] ?? '',
      statusCode: json['statusCode'] ?? 200,
    );
  }

  @override
  List<Object?> get props => [
        data,
        page,
        total,
        perPage,
        nextPage,
        previousPage,
        lastPage,
        message,
        statusCode,
      ];
}

class PriceHistoryItemModel extends Equatable {
  final String date;
  final int price;

  const PriceHistoryItemModel({
    required this.date,
    required this.price,
  });

  factory PriceHistoryItemModel.fromJson(Map<String, dynamic> json) {
    return PriceHistoryItemModel(
      date: json['hg_tgl'] ?? '',
      price: json['harga'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [date, price];
}
