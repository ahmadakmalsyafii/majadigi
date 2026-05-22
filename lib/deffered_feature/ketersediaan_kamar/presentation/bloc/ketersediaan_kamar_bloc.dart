import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:majadigi/deffered_feature/ketersediaan_kamar/domain/usecases/get_room_availability_usecase.dart';
import 'package:majadigi/deffered_feature/ketersediaan_kamar/presentation/bloc/ketersediaan_kamar_event.dart';
import 'package:majadigi/deffered_feature/ketersediaan_kamar/presentation/bloc/ketersediaan_kamar_state.dart';

class KetersediaanKamarBloc extends Bloc<KetersediaanKamarEvent, KetersediaanKamarState> {
  final GetRoomAvailabilityUseCase getRoomAvailability;

  KetersediaanKamarBloc({required this.getRoomAvailability}) : super(KetersediaanKamarInitial()) {
    on<FetchRoomAvailability>(_onFetchRoomAvailability);
  }

  Future<void> _onFetchRoomAvailability(
    FetchRoomAvailability event,
    Emitter<KetersediaanKamarState> emit,
  ) async {
    emit(KetersediaanKamarLoading());
    final result = await getRoomAvailability(event.hospitalName);
    result.fold(
      (failure) => emit(KetersediaanKamarError(failure.message)),
      (data) => emit(KetersediaanKamarLoaded(data)),
    );
  }
}
