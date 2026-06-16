import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:majadigi/deffered_feature/destinasi_wisata/domain/entity/destination_ticket_entity.dart';
import 'package:majadigi/deffered_feature/destinasi_wisata/domain/usecases/create_destination_ticket_usecase.dart';

part 'destination_ticket_event.dart';
part 'destination_ticket_state.dart';

@injectable
class DestinationTicketBloc extends Bloc<DestinationTicketEvent, DestinationTicketState> {
  final CreateDestinationTicketUsecase createDestinationTicketUsecase;

  DestinationTicketBloc(this.createDestinationTicketUsecase) : super(DestinationTicketInitial()) {
    on<CreateDestinationTicketEvent>(_onCreateTicketEvent);
  }

  Future<void> _onCreateTicketEvent(
    CreateDestinationTicketEvent event,
    Emitter<DestinationTicketState> emit,
  ) async {
    emit(DestinationTicketLoading());
    
    final result = await createDestinationTicketUsecase(
      userId: event.userId,
      name: event.name,
      nik: event.nik,
      date: event.date,
      totalTicket: event.totalTicket,
      paymentMethod: event.paymentMethod,
      destinationId: event.destinationId,
      destinationName: event.destinationName,
      priceAmount: event.priceAmount,
    );

    result.fold(
      (failure) {
        emit(DestinationTicketError(failure));
        event.completer?.completeError(failure);
      },
      (ticket) {
        emit(DestinationTicketSuccess(ticket));
        event.completer?.complete();
      },
    );
  }
}
