import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_activity_histories_usecase.dart';
import 'activity_history_event.dart';
import 'activity_history_state.dart';

@injectable
class ActivityHistoryBloc extends Bloc<ActivityHistoryEvent, ActivityHistoryState> {
  final GetActivityHistoriesUseCase getActivityHistoriesUseCase;

  ActivityHistoryBloc({required this.getActivityHistoriesUseCase}) : super(ActivityHistoryInitial()) {
    on<FetchActivityHistories>(_onFetchActivityHistories);
  }

  Future<void> _onFetchActivityHistories(
    FetchActivityHistories event,
    Emitter<ActivityHistoryState> emit,
  ) async {
    emit(ActivityHistoryLoading());
    final result = await getActivityHistoriesUseCase.execute(event.userId);

    result.fold(
      (failure) => emit(ActivityHistoryError(message: failure.message)),
      (histories) => emit(ActivityHistoryLoaded(histories: histories)),
    );
  }
}
