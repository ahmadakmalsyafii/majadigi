import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:majadigi/deffered_feature/islamic_center/domain/entity/islamic_center_ticket_entity.dart';
import 'package:majadigi/deffered_feature/islamic_center/domain/usecases/create_islamic_ticket_usecase.dart';

part 'islamic_center_ticket_event.dart';
part 'islamic_center_ticket_state.dart';

@injectable
class IslamicCenterTicketBloc extends Bloc<IslamicCenterTicketEvent, IslamicCenterTicketState> {
  final CreateIslamicTicketUsecase createIslamicTicketUsecase;

  IslamicCenterTicketBloc(this.createIslamicTicketUsecase) : super(IslamicCenterTicketInitial()) {
    on<CreateIslamicCenterTicketEvent>(_onCreateTicketEvent);
  }

  Future<void> _onCreateTicketEvent(
    CreateIslamicCenterTicketEvent event,
    Emitter<IslamicCenterTicketState> emit,
  ) async {
    emit(IslamicCenterTicketLoading());
    
    final result = await createIslamicTicketUsecase(
      userId: event.userId,
      name: event.name,
      reservDate: event.reservDate,
      reservTime: event.reservTime,
      roomName: event.roomName,
      paymentMethod: event.paymentMethod,
      facilityId: event.facilityId,
      roomId: event.roomId,
    );

    result.fold(
      (failure) {
        emit(IslamicCenterTicketError(failure));
        event.completer?.completeError(failure);
      },
      (ticket) {
        emit(IslamicCenterTicketSuccess(ticket));
        event.completer?.complete();
      },
    );
  }
}
