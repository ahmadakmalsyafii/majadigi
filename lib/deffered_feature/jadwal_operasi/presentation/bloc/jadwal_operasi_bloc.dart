import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:majadigi/deffered_feature/jadwal_operasi/domain/usecases/get_jadwal_operasi_usecase.dart';
import 'package:majadigi/deffered_feature/jadwal_operasi/presentation/bloc/jadwal_operasi_event.dart';
import 'package:majadigi/deffered_feature/jadwal_operasi/presentation/bloc/jadwal_operasi_state.dart';

class JadwalOperasiBloc extends Bloc<JadwalOperasiEvent, JadwalOperasiState> {
  final GetJadwalOperasiUseCase getJadwalOperasiUseCase;

  JadwalOperasiBloc({required this.getJadwalOperasiUseCase}) : super(const JadwalOperasiState()) {
    on<FetchJadwalOperasiEvent>(_onFetchJadwalOperasi);
  }

  Future<void> _onFetchJadwalOperasi(FetchJadwalOperasiEvent event, Emitter<JadwalOperasiState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await getJadwalOperasiUseCase(date: event.date, surgeryName: event.surgeryName);
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (data) => emit(state.copyWith(isLoading: false, data: data)),
    );
  }
}
