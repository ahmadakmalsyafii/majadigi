import 'package:equatable/equatable.dart';

class DestinationTicketEntity extends Equatable {
  final String id;
  final int orderNumber;
  final String userId;
  final String name;
  final String nik;
  final String date;
  final int totalTicket;
  final String paymentMethod;
  final String destinationId;
  final String destinationName;
  final int priceAmount;
  final String status;

  const DestinationTicketEntity({
    required this.id,
    required this.orderNumber,
    required this.userId,
    required this.name,
    required this.nik,
    required this.date,
    required this.totalTicket,
    required this.paymentMethod,
    required this.destinationId,
    required this.destinationName,
    required this.priceAmount,
    required this.status,
  });

  @override
  List<Object?> get props => [
        id,
        orderNumber,
        userId,
        name,
        nik,
        date,
        totalTicket,
        paymentMethod,
        destinationId,
        destinationName,
        priceAmount,
        status,
      ];
}
