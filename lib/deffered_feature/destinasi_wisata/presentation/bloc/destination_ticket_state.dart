part of 'destination_ticket_bloc.dart';

abstract class DestinationTicketState extends Equatable {
  const DestinationTicketState();
  
  @override
  List<Object> get props => [];
}

class DestinationTicketInitial extends DestinationTicketState {}

class DestinationTicketLoading extends DestinationTicketState {}

class DestinationTicketSuccess extends DestinationTicketState {
  final DestinationTicketEntity ticket;

  const DestinationTicketSuccess(this.ticket);

  @override
  List<Object> get props => [ticket];
}

class DestinationTicketError extends DestinationTicketState {
  final String message;

  const DestinationTicketError(this.message);

  @override
  List<Object> get props => [message];
}
