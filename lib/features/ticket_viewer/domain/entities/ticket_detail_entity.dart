import 'package:equatable/equatable.dart';

class TicketDetailEntity extends Equatable {
  final String id;
  final String orderNumber;
  final String name;
  final String status;
  final String paymentMethod;
  final String ticketType;
  final Map<String, dynamic> specificDetails;

  const TicketDetailEntity({
    required this.id,
    required this.orderNumber,
    required this.name,
    required this.status,
    required this.paymentMethod,
    required this.ticketType,
    required this.specificDetails,
  });

  @override
  List<Object?> get props => [
    id,
    orderNumber,
    name,
    status,
    paymentMethod,
    ticketType,
    specificDetails,
  ];
}
