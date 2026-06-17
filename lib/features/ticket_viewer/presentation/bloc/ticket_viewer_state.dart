import 'package:equatable/equatable.dart';
import '../../domain/entities/ticket_detail_entity.dart';

abstract class TicketViewerState extends Equatable {
  const TicketViewerState();

  @override
  List<Object?> get props => [];
}

class TicketViewerInitial extends TicketViewerState {}

class TicketViewerLoading extends TicketViewerState {}

class TicketViewerLoaded extends TicketViewerState {
  final TicketDetailEntity ticket;

  const TicketViewerLoaded({required this.ticket});

  @override
  List<Object?> get props => [ticket];
}

class TicketViewerError extends TicketViewerState {
  final String message;

  const TicketViewerError({required this.message});

  @override
  List<Object?> get props => [message];
}
