import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/features/beranda/domain/entity/banner_entity.dart';
import 'package:majadigi/features/beranda/domain/entity/jatim_angka_entity.dart';
import 'package:majadigi/features/beranda/domain/entity/service_entity.dart';
import 'package:majadigi/features/beranda/domain/usecases/get_all_banner_usecase.dart';
import 'package:majadigi/features/beranda/domain/usecases/get_jatim_angka_usecase.dart';
import 'package:majadigi/features/beranda/domain/usecases/get_service_section_usecase.dart';
import 'package:majadigi/features/beranda/presentation/bloc/beranda_event.dart';
import 'package:majadigi/features/beranda/presentation/bloc/beranda_state.dart';

class BerandaBloc extends Bloc<BerandaEvent, BerandaState> {
  final GetAllBannerUseCase getBannerUseCase;
  final GetServiceSectionUsecase getServiceUseCase;
  final GetJatimAngkaUseCase getJatimAngkaUseCase;

  BerandaBloc({
    required this.getBannerUseCase,
    required this.getServiceUseCase,
    required this.getJatimAngkaUseCase,
  }) : super(const BerandaState()) {
    on<GetBerandaDataEvent>(_onGetBerandaData);
    on<GetAllBannerEvent>(_onGetAllBanner);
    on<GetAllServiceEvent>(_onGetAllService);
  }

  Future<void> _onGetBerandaData(
    GetBerandaDataEvent event,
    Emitter<BerandaState> emit,
  ) async {
    emit(state.copyWith(
      bannerStatus: BerandaSectionStatus.loading,
      serviceStatus: BerandaSectionStatus.loading,
      jatimAngkaStatus: BerandaSectionStatus.loading,
    ));

    await Future.wait([
      _fetchBanners(emit),
      _fetchServices(emit),
      _fetchJatimAngka(emit),
    ]);
  }

  Future<void> _fetchBanners(Emitter<BerandaState> emit) async {
    final result = await getBannerUseCase.call();
    result.fold(
      (failure) {
        emit(state.copyWith(
          bannerStatus: BerandaSectionStatus.error,
          bannerError: failure.message,
        ));
      },
      (data) {
        emit(state.copyWith(
          bannerStatus: BerandaSectionStatus.loaded,
          banners: data,
        ));
      },
    );
  }

  Future<void> _fetchServices(Emitter<BerandaState> emit) async {
    final result = await getServiceUseCase.call();
    result.fold(
      (failure) {
        emit(state.copyWith(
          serviceStatus: BerandaSectionStatus.error,
          serviceError: failure.message,
        ));
      },
      (data) {
        emit(state.copyWith(
          serviceStatus: BerandaSectionStatus.loaded,
          services: data,
        ));
      },
    );
  }

  Future<void> _fetchJatimAngka(Emitter<BerandaState> emit) async {
    final result = await getJatimAngkaUseCase.call();
    result.fold(
      (failure) {
        emit(state.copyWith(
          jatimAngkaStatus: BerandaSectionStatus.error,
          jatimAngkaError: failure.message,
        ));
      },
      (data) {
        emit(state.copyWith(
          jatimAngkaStatus: BerandaSectionStatus.loaded,
          jatimAngka: data,
        ));
      },
    );
  }

  Future<void> _onGetAllService(
    GetAllServiceEvent event,
    Emitter<BerandaState> emit,
  ) async {
    emit(state.copyWith(serviceStatus: BerandaSectionStatus.loading));
    await _fetchServices(emit);
  }

  Future<void> _onGetAllBanner(
    GetAllBannerEvent event,
    Emitter<BerandaState> emit,
  ) async {
    emit(state.copyWith(bannerStatus: BerandaSectionStatus.loading));
    await _fetchBanners(emit);
  }
}
