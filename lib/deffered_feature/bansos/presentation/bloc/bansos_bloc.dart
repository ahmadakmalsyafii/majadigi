import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:majadigi/deffered_feature/bansos/domain/usecases/get_bansos_by_nik_usecase.dart';
import 'package:majadigi/deffered_feature/bansos/presentation/bloc/bansos_event.dart';
import 'package:majadigi/deffered_feature/bansos/presentation/bloc/bansos_state.dart';

class BansosBloc extends Bloc<BansosEvent, BansosState> {
  final GetBansosByNikUseCase getBansosByNik;

  BansosBloc({required this.getBansosByNik}) : super(BansosInitial()) {
    on<SearchBansosEvent>(_onSearchBansos);
  }

  Future<void> _onSearchBansos(
    SearchBansosEvent event,
    Emitter<BansosState> emit,
  ) async {
    emit(BansosLoading());
    final result = await getBansosByNik(event.nik);

    result.fold(
      (failure) => emit(BansosError(failure.message)),
      (bansos) {
        if (bansos != null) {
          emit(BansosLoaded(bansos));
        } else {
          emit(BansosNotFound());
        }
      },
    );
  }
}
