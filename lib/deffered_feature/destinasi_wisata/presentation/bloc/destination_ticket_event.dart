part of 'destination_ticket_bloc.dart';

abstract class DestinationTicketEvent extends Equatable {
  const DestinationTicketEvent();

  @override
  List<Object?> get props => [];
}

class CreateDestinationTicketEvent extends DestinationTicketEvent {
  final String userId;
  final String name;
  final String nik;
  final String date;
  final int totalTicket;
  final String paymentMethod;
  final String destinationId;
  final String destinationName;
  final int priceAmount;
  final Completer<void>? completer;

  const CreateDestinationTicketEvent({
    required this.userId,
    required this.name,
    required this.nik,
    required this.date,
    required this.totalTicket,
    required this.paymentMethod,
    required this.destinationId,
    required this.destinationName,
    required this.priceAmount,
    this.completer,
  });

  @override
  List<Object?> get props => [
        userId,
        name,
        nik,
        date,
        totalTicket,
        paymentMethod,
        destinationId,
        destinationName,
        priceAmount,
        completer,
      ];
}
