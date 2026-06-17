import 'package:equatable/equatable.dart';

abstract class TicketViewerEvent extends Equatable {
  const TicketViewerEvent();

  @override
  List<Object?> get props => [];
}

class FetchTicketDetailEvent extends TicketViewerEvent {
  final String ticketId;
  final String type;

  const FetchTicketDetailEvent({required this.ticketId, required this.type});

  @override
  List<Object?> get props => [ticketId, type];
}
