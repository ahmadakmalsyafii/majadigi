import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:majadigi/features/beranda/domain/usecases/get_all_service_usecase.dart';
import 'package:majadigi/features/layanan/domain/usecases/get_katalog_layanan_usecase.dart';
import 'package:majadigi/features/layanan/presentation/bloc/layanan_event.dart';
import 'package:majadigi/features/layanan/presentation/bloc/layanan_state.dart';

@injectable
class LayananBloc extends Bloc<LayananEvent, LayananState> {
  final GetAllServiceUsecase getAllServiceUseCase;
  final GetKatalogLayananUseCase getKatalogLayananUseCase;

  LayananBloc({
    required this.getAllServiceUseCase,
    required this.getKatalogLayananUseCase,
  }) : super(LayananInitial()) {
    on<FetchLayananData>(_onFetchLayananData);
    on<SearchLayananEvent>(_onSearchLayanan);
  }

  Future<void> _onFetchLayananData(
    FetchLayananData event,
    Emitter<LayananState> emit,
  ) async {
    emit(LayananLoading());

    final serviceResult = await getAllServiceUseCase();
    final katalogResult = await getKatalogLayananUseCase();

    if (serviceResult.isLeft()) {
      final failure = serviceResult.fold((l) => l, (r) => null);
      emit(LayananError(failure!.message));
      return;
    }

    if (katalogResult.isLeft()) {
      final failure = katalogResult.fold((l) => l, (r) => null);
      emit(LayananError(failure!.message));
      return;
    }

    final services = serviceResult.fold((l) => null, (r) => r)!;
    final katalog = katalogResult.fold((l) => null, (r) => r)!;

    emit(
      LayananLoaded(
        services: services,
        filteredServices: services,
        katalogLayanan: katalog,
        filteredKatalogLayanan: katalog,
      ),
    );
  }

  void _onSearchLayanan(SearchLayananEvent event, Emitter<LayananState> emit) {
    if (state is LayananLoaded) {
      final currentState = state as LayananLoaded;
      final query = event.query.toLowerCase();

      final filteredServices = currentState.services.where((service) {
        return service.name.toLowerCase().contains(query) ||
            service.description.toLowerCase().contains(query);
      }).toList();

      final filteredKatalog = currentState.katalogLayanan.where((katalog) {
        return katalog.nama.toLowerCase().contains(query);
      }).toList();

      emit(
        LayananLoaded(
          services: currentState.services,
          katalogLayanan: currentState.katalogLayanan,
          filteredServices: filteredServices,
          filteredKatalogLayanan: filteredKatalog,
        ),
      );
    }
  }
}
