import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:majadigi/features/beranda/domain/entitiy/banner_entity.dart';
import 'package:majadigi/features/beranda/domain/entitiy/service_entity.dart';
import 'package:majadigi/features/beranda/domain/usecases/get_all_banner_usecase.dart';
import 'package:majadigi/features/beranda/domain/usecases/get_all_service_usecase.dart';
import 'package:majadigi/features/beranda/domain/usecases/get_jatim_angka_usecase.dart';
import 'package:majadigi/features/beranda/presentation/bloc/beranda_event.dart';
import 'package:majadigi/features/beranda/presentation/bloc/beranda_state.dart';
import 'package:majadigi/features/beranda/domain/entitiy/jatim_angka_entity.dart';

class BerandaBloc extends Bloc<BerandaEvent, BerandaState> {
  final GetAllBannerUseCase getBannerUseCase;
  final GetAllServiceUsecase getServiceUseCase;
  final GetJatimAngkaUseCase getJatimAngkaUseCase;

  BerandaBloc({
    required this.getBannerUseCase,
    required this.getServiceUseCase,
    required this.getJatimAngkaUseCase,
  }) : super(const BerandaInitial()) {
    on<GetBerandaDataEvent>(_onGetBerandaData);
    on<GetAllBannerEvent>(_onGetAllBanner);
    on<GetAllServiceEvent>(_onGetAllService);
  }

  Future<void> _onGetBerandaData(
      GetBerandaDataEvent event,
      Emitter<BerandaState> emit,
      ) async {
    emit(const BerandaLoading());

    try {
      final bannerResult = await getBannerUseCase.call();
      final serviceResult = await getServiceUseCase.call();
      final jatimAngkaResult = await getJatimAngkaUseCase.call();
      String? errorMessage;

      final List<BannerEntity> banners = bannerResult.fold(
            (failure) {
          errorMessage = failure.message;
          return [];
        },
            (data) => data,
      );

      final List<ServiceEntity> services = serviceResult.fold(
          (failure){
            errorMessage = failure.message;
            return [];
          }, (data) => data
      );

      final List<JatimAngkaEntity> jatimAngka = jatimAngkaResult.fold(
          (failure) {
            errorMessage = failure.message;
            return [];
          },
          (data) => data
      );

      if (errorMessage != null) {
        emit(BerandaError(
          message: errorMessage!,
          failure: Exception(errorMessage) as dynamic,
        ));
      } else {
        emit(BerandaLoaded(
          banners: banners,
          services: services,
          jatimAngka: jatimAngka,
        ));
      }
    } catch (e) {
      emit(BerandaError(
        message: e.toString(),
        failure: Exception(e.toString()) as dynamic,
      ));
    }
  }

  Future<void> _onGetAllService(
      GetAllServiceEvent event,
      Emitter<BerandaState> emit,
      ) async {
    emit(const BerandaLoadingServices());

    final result = await getServiceUseCase.call();

    result.fold(
          (failure) {
        emit(ServiceError(
          message: failure.message,
          failure: failure,
        ));
      },
          (services) {
        if (state is BerandaLoaded) {
          emit(BerandaLoadedServices(services: services));
        } else {
          emit(BerandaLoadedServices(
            services: services,
          ));
        }
      },
    );
  }





  Future<void> _onGetAllBanner(
      GetAllBannerEvent event,
      Emitter<BerandaState> emit,
      ) async {
    emit(const BerandaLoadingBanners());

    final result = await getBannerUseCase.call();

    result.fold(
          (failure) {
        emit(BannerError(
          message: failure.message,
          failure: failure,
        ));
      },
          (banners) {
        if (state is BerandaLoaded) {
          emit(BerandaLoadedBanners(banners: banners));
        } else {
          emit(BerandaLoadedBanners(
            banners: banners,
          ));
        }
      },
    );
  }
}

