import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:majadigi/deffered_feature/no_darurat/domain/entity/kab_kota_entity.dart';
import 'package:majadigi/deffered_feature/no_darurat/domain/usecases/get_emergency_numbers_usecase.dart';
import 'package:majadigi/deffered_feature/no_darurat/domain/usecases/get_kab_kota_usecase.dart';
import 'package:majadigi/deffered_feature/no_darurat/presentation/bloc/emergency/emergency_event.dart';
import 'package:majadigi/deffered_feature/no_darurat/presentation/bloc/emergency/emergency_state.dart';

class EmergencyBloc extends Bloc<EmergencyEvent, EmergencyState> {
  final GetEmergencyNumbersUseCase _getEmergencyNumbers;
  final GetKabKotaUseCase _getKabKota;

  EmergencyBloc({
    required GetEmergencyNumbersUseCase getEmergencyNumbers,
    required GetKabKotaUseCase getKabKota,
  })  : _getEmergencyNumbers = getEmergencyNumbers,
        _getKabKota = getKabKota,
        super(const EmergencyInitial()) {
    on<LoadEmergencyData>(_onLoadEmergencyData);
    on<ChangeTab>(_onChangeTab);
    on<SelectCity>(_onSelectCity);
  }

  Future<void> _onLoadEmergencyData(
    LoadEmergencyData event,
    Emitter<EmergencyState> emit,
  ) async {
    emit(EmergencyLoading(
      tabIndex: state.tabIndex,
      kabKotaList: state.kabKotaList,
    ));

    // Fetch kab-kota list jika belum ada
    List<KabKotaEntity> kabKotaList = state.kabKotaList;
    if (kabKotaList.isEmpty) {
      final kabKotaResult = await _getKabKota();
      kabKotaResult.fold(
        (_) {}, // Abaikan error kab-kota, tetap lanjut fetch numbers
        (data) => kabKotaList = data,
      );
    }

    // Fetch nomor darurat (tanpa filter = semua)
    final numbersResult = await _getEmergencyNumbers(
      kabKotaId: state.selectedKabKotaId,
    );

    numbersResult.fold(
      (failure) => emit(EmergencyError(
        message: failure.message,
        tabIndex: state.tabIndex,
        kabKotaList: kabKotaList,
        selectedKabKotaId: state.selectedKabKotaId,
        selectedKabKotaNama: state.selectedKabKotaNama,
      )),
      (numbers) => emit(EmergencyLoaded(
        numbers: numbers,
        tabIndex: state.tabIndex,
        kabKotaList: kabKotaList,
        selectedKabKotaId: state.selectedKabKotaId,
        selectedKabKotaNama: state.selectedKabKotaNama,
      )),
    );
  }

  void _onChangeTab(ChangeTab event, Emitter<EmergencyState> emit) {
    if (event.index == 1) {
      if (state is EmergencyLoaded) {
        emit(EmergencyLoaded(
          numbers: (state as EmergencyLoaded).numbers,
          tabIndex: 1,
          kabKotaList: state.kabKotaList,
          selectedKabKotaId: state.selectedKabKotaId,
          selectedKabKotaNama: state.selectedKabKotaNama,
        ));
      } else {
        add(const LoadEmergencyData());
      }
    } else {
      if (state is EmergencyLoaded) {
        emit(EmergencyLoaded(
          numbers: (state as EmergencyLoaded).numbers,
          tabIndex: 0,
          kabKotaList: state.kabKotaList,
          selectedKabKotaId: state.selectedKabKotaId,
          selectedKabKotaNama: state.selectedKabKotaNama,
        ));
      } else {
        emit(EmergencyInitial(
          tabIndex: 0,
          kabKotaList: state.kabKotaList,
        ));
      }
    }
  }

  Future<void> _onSelectCity(
    SelectCity event,
    Emitter<EmergencyState> emit,
  ) async {
    emit(EmergencyLoading(
      tabIndex: state.tabIndex,
      kabKotaList: state.kabKotaList,
      selectedKabKotaId: event.kabKotaId,
      selectedKabKotaNama: event.kabKotaNama,
    ));

    final result =
        await _getEmergencyNumbers(kabKotaId: event.kabKotaId);

    result.fold(
      (failure) => emit(EmergencyError(
        message: failure.message,
        tabIndex: state.tabIndex,
        kabKotaList: state.kabKotaList,
        selectedKabKotaId: event.kabKotaId,
        selectedKabKotaNama: event.kabKotaNama,
      )),
      (numbers) => emit(EmergencyLoaded(
        numbers: numbers,
        tabIndex: state.tabIndex,
        kabKotaList: state.kabKotaList,
        selectedKabKotaId: event.kabKotaId,
        selectedKabKotaNama: event.kabKotaNama,
      )),
    );
  }
}
