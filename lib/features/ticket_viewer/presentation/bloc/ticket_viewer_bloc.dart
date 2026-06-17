import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_ticket_detail_usecase.dart';
import 'ticket_viewer_event.dart';
import 'ticket_viewer_state.dart';

@injectable
class TicketViewerBloc extends Bloc<TicketViewerEvent, TicketViewerState> {
  final GetTicketDetailUsecase getTicketDetailUsecase;

  TicketViewerBloc(this.getTicketDetailUsecase) : super(TicketViewerInitial()) {
    on<FetchTicketDetailEvent>((event, emit) async {
      emit(TicketViewerLoading());
      try {
        final ticket = await getTicketDetailUsecase(event.ticketId, event.type);
        emit(TicketViewerLoaded(ticket: ticket));
      } catch (e) {
        emit(TicketViewerError(message: e.toString()));
      }
    });
  }
}
