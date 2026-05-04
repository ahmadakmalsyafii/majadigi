import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:majadigi/features/beranda/domain/entitiy/banner_entity.dart';
import 'package:majadigi/features/beranda/domain/usecases/get_all_banner_usecase.dart';
import 'package:majadigi/features/beranda/presentation/bloc/beranda_event.dart';
import 'package:majadigi/features/beranda/presentation/bloc/beranda_state.dart';

class BerandaBloc extends Bloc<BerandaEvent, BerandaState> {
  final GetAllBannersUseCase getBannersUseCase;

  BerandaBloc({
    required this.getBannersUseCase
  }) : super(const BerandaInitial()) {
    on<GetBerandaDataEvent>(_onGetBerandaData);
    on<GetAllBannersEvent>(_onGetAllBanners);
  }

  Future<void> _onGetBerandaData(
      GetBerandaDataEvent event,
      Emitter<BerandaState> emit,
      ) async {
    emit(const BerandaLoading());

    try {
      final bannerResult = await getBannersUseCase.call();
      String? errorMessage;

      final List<BannerEntity> banners = bannerResult.fold(
            (failure) {
          errorMessage = failure.message;
          return [];
        },
            (data) => data,
      );

      if (errorMessage != null) {
        emit(BerandaError(
          message: errorMessage!,
          failure: Exception(errorMessage) as dynamic,
        ));
      } else {
        emit(BerandaLoaded(
          banners: banners,

        ));
      }
    } catch (e) {
      emit(BerandaError(
        message: e.toString(),
        failure: Exception(e.toString()) as dynamic,
      ));
    }
  }





  Future<void> _onGetAllBanners(
      GetAllBannersEvent event,
      Emitter<BerandaState> emit,
      ) async {
    emit(const BerandaLoadingBanners());

    final result = await getBannersUseCase.call();

    result.fold(
          (failure) {
        emit(BerandaError(
          message: failure.message,
          failure: failure,
        ));
      },
          (banners) {
        if (state is BerandaLoaded) {
          emit(BerandaLoaded(banners: banners));
        } else {
          emit(BerandaLoaded(
            banners: banners,

          ));
        }
      },
    );
  }
}

