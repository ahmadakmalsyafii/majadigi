
import 'package:bloc/bloc.dart';
import 'package:majadigi/features/beranda/domain/usecases/get_all_service_usecase.dart';
import 'package:majadigi/features/list_layanan/presentation/bloc/list_layanan_event.dart';
import 'package:majadigi/features/list_layanan/presentation/bloc/list_layanan_state.dart';

class ListLayananBloc extends Bloc<ListLayananEvent, ListLayananState>{
  final GetAllServiceUsecase getAllServiceUsecase;

  ListLayananBloc({
    required this.getAllServiceUsecase,
    }) : super(const ListLayananInitial()) {
    on<GetListLayananEvent>(_onGetListLayanan);
    on<SearchListLayananEvent>(_onSearchListLayanan);
  }

  Future<void> _onGetListLayanan(
    GetListLayananEvent event,
    Emitter<ListLayananState> emit,
  ) async {
    emit(ListLayananLoading());
      final result = await getAllServiceUsecase.call();



      result.fold(
            (failure) {
          emit(ListLayananError(message: failure.message));
        },
            (services) {
          emit(ListLayananLoaded(services: services, filteredServices: services));
        },
      );
  }

  void _onSearchListLayanan(
    SearchListLayananEvent event,
    Emitter<ListLayananState> emit,
  ) {
    if (state is ListLayananLoaded) {
      final currentState = state as ListLayananLoaded;
      final query = event.query.toLowerCase();
      
      final filteredList = currentState.services.where((service) {
        return service.name.toLowerCase().contains(query) ||
               service.description.toLowerCase().contains(query);
      }).toList();
      
      emit(ListLayananLoaded(
        services: currentState.services,
        filteredServices: filteredList,
      ));
    }
  }
}