import 'package:equatable/equatable.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/domain/entities/commodity_entity.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/domain/entities/commodity_detail_entity.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/domain/entities/city_price_entity.dart';

abstract class HargaBahanPokokState extends Equatable {
  const HargaBahanPokokState();

  @override
  List<Object?> get props => [];
}

class HargaBahanPokokInitial extends HargaBahanPokokState {}

class CommodityListLoading extends HargaBahanPokokState {}

class CommodityListLoaded extends HargaBahanPokokState {
  final List<CommodityItemEntity> commodities;
  const CommodityListLoaded(this.commodities);
  @override
  List<Object?> get props => [commodities];
}

class CommodityListError extends HargaBahanPokokState {
  final String message;
  const CommodityListError(this.message);
  @override
  List<Object?> get props => [message];
}

class CommodityDetailLoading extends HargaBahanPokokState {}

class CommodityDetailLoaded extends HargaBahanPokokState {
  final CommodityDetailDataEntity detail;
  final List<CityPriceEntity> cityPrices;
  const CommodityDetailLoaded(this.detail, this.cityPrices);
  @override
  List<Object?> get props => [detail, cityPrices];
}

class CommodityDetailError extends HargaBahanPokokState {
  final String message;
  const CommodityDetailError(this.message);
  @override
  List<Object?> get props => [message];
}
