part of 'islamic_center_ticket_bloc.dart';

abstract class IslamicCenterTicketState extends Equatable {
  const IslamicCenterTicketState();
  
  @override
  List<Object> get props => [];
}

class IslamicCenterTicketInitial extends IslamicCenterTicketState {}

class IslamicCenterTicketLoading extends IslamicCenterTicketState {}

class IslamicCenterTicketSuccess extends IslamicCenterTicketState {
  final IslamicCenterTicketEntity ticket;

  const IslamicCenterTicketSuccess(this.ticket);

  @override
  List<Object> get props => [ticket];
}

class IslamicCenterTicketError extends IslamicCenterTicketState {
  final String message;

  const IslamicCenterTicketError(this.message);

  @override
  List<Object> get props => [message];
}
