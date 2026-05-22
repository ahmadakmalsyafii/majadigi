import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:majadigi/deffered_feature/antrean_pasien/domain/usecases/get_antrean_usecase.dart';
import 'package:majadigi/deffered_feature/antrean_pasien/domain/usecases/get_dokter_usecase.dart';
import 'package:majadigi/deffered_feature/antrean_pasien/domain/usecases/get_poli_usecase.dart';
import 'package:majadigi/deffered_feature/antrean_pasien/presentation/bloc/antrean_event.dart';
import 'package:majadigi/deffered_feature/antrean_pasien/presentation/bloc/antrean_state.dart';

class AntreanBloc extends Bloc<AntreanEvent, AntreanState> {
  final GetPoliUseCase getPoliUseCase;
  final GetDokterUseCase getDokterUseCase;
  final GetAntreanUseCase getAntreanUseCase;

  AntreanBloc({
    required this.getPoliUseCase,
    required this.getDokterUseCase,
    required this.getAntreanUseCase,
  }) : super(const AntreanState()) {
    on<FetchPoliEvent>(_onFetchPoli);
    on<FetchDokterEvent>(_onFetchDokter);
    on<SelectDokterEvent>(_onSelectDokter);
    on<CekAntreanEvent>(_onCekAntrean);
  }

  Future<void> _onFetchPoli(FetchPoliEvent event, Emitter<AntreanState> emit) async {
    emit(state.copyWith(isLoadingPoli: true, errorMessage: null));
    final result = await getPoliUseCase();
    result.fold(
      (failure) => emit(state.copyWith(isLoadingPoli: false, errorMessage: failure.message)),
      (data) => emit(state.copyWith(isLoadingPoli: false, poliList: data)),
    );
  }

  Future<void> _onFetchDokter(FetchDokterEvent event, Emitter<AntreanState> emit) async {
    emit(state.copyWith(
      isLoadingDokter: true,
      selectedPoli: event.selectedPoli,
      clearDokter: true,
      dokterList: [],
      errorMessage: null,
    ));
    final result = await getDokterUseCase(event.selectedPoli.value);
    result.fold(
      (failure) => emit(state.copyWith(isLoadingDokter: false, errorMessage: failure.message)),
      (data) => emit(state.copyWith(isLoadingDokter: false, dokterList: data)),
    );
  }

  void _onSelectDokter(SelectDokterEvent event, Emitter<AntreanState> emit) {
    emit(state.copyWith(selectedDokter: event.selectedDokter));
  }

  Future<void> _onCekAntrean(CekAntreanEvent event, Emitter<AntreanState> emit) async {
    if (state.selectedPoli == null || state.selectedDokter == null) return;
    
    emit(state.copyWith(isLoadingAntrean: true, errorMessage: null));
    final result = await getAntreanUseCase(state.selectedPoli!.value, state.selectedDokter!.value);
    result.fold(
      (failure) => emit(state.copyWith(isLoadingAntrean: false, errorMessage: failure.message)),
      (data) => emit(state.copyWith(isLoadingAntrean: false, antreanResult: data)),
    );
  }
}
