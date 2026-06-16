import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/domain/entities/commodity_detail_entity.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/domain/usecases/get_commodity_price_list_usecase.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/domain/usecases/get_commodity_detail_usecase.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/domain/usecases/get_city_price_list_usecase.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/presentation/bloc/harga_bahan_pokok_event.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/presentation/bloc/harga_bahan_pokok_state.dart';

class HargaBahanPokokBloc
    extends Bloc<HargaBahanPokokEvent, HargaBahanPokokState> {
  final GetCommodityPriceListUseCase getCommodityPriceList;
  final GetCommodityDetailUseCase getCommodityDetail;
  final GetCityPriceListUseCase getCityPriceList;

  HargaBahanPokokBloc({
    required this.getCommodityPriceList,
    required this.getCommodityDetail,
    required this.getCityPriceList,
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
    final detailResult = await getCommodityDetail(event.bpId);

    bool isError = false;
    String errorMessage = '';
    CommodityDetailDataEntity? detailData;

    detailResult.fold(
      (failure) {
        isError = true;
        errorMessage = failure.message;
      },
      (detailResponse) {
        detailData = detailResponse.data;
      },
    );

    if (isError) {
      emit(CommodityDetailError(errorMessage));
      return;
    }

    final cityResult = await getCityPriceList(event.bpId);
    cityResult.fold(
      (failure) => emit(CommodityDetailError(failure.message)),
      (cityResponse) =>
          emit(CommodityDetailLoaded(detailData!, cityResponse.data)),
    );
  }
}
