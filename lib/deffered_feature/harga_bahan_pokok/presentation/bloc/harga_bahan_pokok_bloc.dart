import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/domain/entities/commodity_detail_entity.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/domain/usecases/get_commodity_price_list_usecase.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/domain/usecases/get_commodity_detail_usecase.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/domain/usecases/get_city_price_list_usecase.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/domain/usecases/get_commodity_price_history_usecase.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/presentation/bloc/harga_bahan_pokok_event.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/presentation/bloc/harga_bahan_pokok_state.dart';

class HargaBahanPokokBloc
    extends Bloc<HargaBahanPokokEvent, HargaBahanPokokState> {
  final GetCommodityPriceListUseCase getCommodityPriceList;
  final GetCommodityDetailUseCase getCommodityDetail;
  final GetCityPriceListUseCase getCityPriceList;
  final GetCommodityPriceHistoryUseCase getCommodityPriceHistory;

  HargaBahanPokokBloc({
    required this.getCommodityPriceList,
    required this.getCommodityDetail,
    required this.getCityPriceList,
    required this.getCommodityPriceHistory,
  }) : super(HargaBahanPokokInitial()) {
    on<FetchCommodityList>(_onFetchCommodityList);
    on<FetchCommodityDetail>(_onFetchCommodityDetail);
  }

  Future<void> _onFetchCommodityList(
    FetchCommodityList event,
    Emitter<HargaBahanPokokState> emit,
  ) async {
    emit(CommodityListLoading());
    final result = await getCommodityPriceList(
      page: event.page,
      limit: event.limit,
    );
    result.fold((failure) => emit(CommodityListError(failure.message)), (
      response,
    ) {
      var items = response.data.priceList;
      if (event.searchQuery.isNotEmpty) {
        items = items
            .where(
              (item) => item.commodityName.toLowerCase().contains(
                event.searchQuery.toLowerCase(),
              ),
            )
            .toList();
      }
      emit(CommodityListLoaded(items));
    });
  }

  Future<void> _onFetchCommodityDetail(
    FetchCommodityDetail event,
    Emitter<HargaBahanPokokState> emit,
  ) async {
    emit(CommodityDetailLoading());

    final results = await Future.wait([
      getCommodityDetail(event.bpId),
      getCityPriceList(event.bpId),
      getCommodityPriceHistory(event.bpId),
    ]);

    final detailResult = results[0] as dartz.Either;
    final cityResult = results[1] as dartz.Either;
    final historyResult = results[2] as dartz.Either;

    bool isError = false;
    String errorMessage = '';

    detailResult.fold(
      (failure) { isError = true; errorMessage = failure.message; },
      (_) {},
    );
    if (!isError) {
      cityResult.fold(
        (failure) { isError = true; errorMessage = failure.message; },
        (_) {},
      );
    }
    if (!isError) {
      historyResult.fold(
        (failure) { isError = true; errorMessage = failure.message; },
        (_) {},
      );
    }

    if (isError) {
      emit(CommodityDetailError(errorMessage));
      return;
    }

    final detailData = detailResult.fold((_) => null, (r) => r.data);
    final cityData = cityResult.fold((_) => null, (r) => r.data);
    final historyData = historyResult.fold((_) => null, (r) => r.data);

    emit(CommodityDetailLoaded(detailData, cityData, historyData));
  }
}
