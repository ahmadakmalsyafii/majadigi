import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:majadigi/features/layanan/domain/usecases/get_katalog_layanan_usecase.dart';
import 'package:majadigi/features/layanan/presentation/bloc/layanan_event.dart';
import 'package:majadigi/features/layanan/presentation/bloc/layanan_state.dart';

@injectable
class LayananBloc extends Bloc<LayananEvent, LayananState> {
  final GetKatalogLayananUseCase _getKatalogLayanan;

  LayananBloc(this._getKatalogLayanan) : super(LayananInitial()) {
    on<FetchKatalogLayanan>(_onFetchKatalogLayanan);
  }

  Future<void> _onFetchKatalogLayanan(
    FetchKatalogLayanan event,
    Emitter<LayananState> emit,
  ) async {
    emit(LayananLoading());
    final result = await _getKatalogLayanan();
    result.fold(
      (failure) => emit(LayananError(failure.message)),
      (data) => emit(LayananLoaded(data)),
    );
  }
}
