import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:majadigi/deffered_feature/islamic_center/domain/usecases/get_facilities_usecase.dart';
import 'package:majadigi/deffered_feature/islamic_center/presentation/bloc/islamic_center_event.dart';
import 'package:majadigi/deffered_feature/islamic_center/presentation/bloc/islamic_center_state.dart';

class IslamicCenterBloc extends Bloc<IslamicCenterEvent, IslamicCenterState> {
  final GetFacilitiesUseCase getFacilitiesUseCase;

  IslamicCenterBloc({required this.getFacilitiesUseCase})
      : super(IslamicCenterInitial()) {
    on<GetFacilitiesEvent>((event, emit) async {
      emit(IslamicCenterLoading());
      final result = await getFacilitiesUseCase();
      result.fold(
        (failure) => emit(IslamicCenterError(message: failure.message)),
        (facilities) => emit(IslamicCenterLoaded(facilities: facilities)),
      );
    });
  }
}
