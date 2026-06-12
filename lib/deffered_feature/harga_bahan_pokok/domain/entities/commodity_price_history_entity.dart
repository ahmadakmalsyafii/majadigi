import 'package:equatable/equatable.dart';

class CommodityPriceHistoryEntity extends Equatable {
  final List<PriceHistoryItemEntity> data;

  const CommodityPriceHistoryEntity({required this.data});

  @override
  List<Object?> get props => [data];
}

class PriceHistoryItemEntity extends Equatable {
  final String date;
  final int price;

  const PriceHistoryItemEntity({
    required this.date,
    required this.price,
  });

  @override
  List<Object?> get props => [date, price];
}
