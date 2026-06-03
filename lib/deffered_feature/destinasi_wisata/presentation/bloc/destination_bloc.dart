import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:majadigi/deffered_feature/destinasi_wisata/domain/usecases/get_destinations_usecase.dart';
import 'package:majadigi/deffered_feature/destinasi_wisata/presentation/bloc/destination_event.dart';
import 'package:majadigi/deffered_feature/destinasi_wisata/presentation/bloc/destination_state.dart';

class DestinationBloc extends Bloc<DestinationEvent, DestinationState> {
  final GetDestinationsUseCase getDestinationsUseCase;

  DestinationBloc({required this.getDestinationsUseCase}) : super(DestinationInitial()) {
    on<FetchDestinationsEvent>((event, emit) async {
      emit(DestinationLoading());
      final result = await getDestinationsUseCase();
      
      result.fold(
        (failure) => emit(DestinationError(failure.message)),
        (destinations) {
          // Extract unique categories from all destinations
          final Set<String> categoriesSet = {};
          for (var dest in destinations) {
            categoriesSet.addAll(dest.category);
          }
          final availableCategories = categoriesSet.toList();
          availableCategories.sort(); // Optional: Sort categories alphabetically

          emit(DestinationLoaded(
            destinations: destinations,
            availableCategories: availableCategories,
          ));
        },
      );
    });
  }
}
