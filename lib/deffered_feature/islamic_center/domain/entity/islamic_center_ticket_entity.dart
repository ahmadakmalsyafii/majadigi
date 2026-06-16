import 'package:equatable/equatable.dart';

class IslamicCenterTicketEntity extends Equatable {
  final String id;
  final int orderNumber;
  final String userId;
  final String name;
  final String reservDate;
  final String reservTime;
  final String status;
  final String roomName;
  final String paymentMethod;
  final String facilityId;
  final String roomId;

  const IslamicCenterTicketEntity({
    required this.id,
    required this.orderNumber,
    required this.userId,
    required this.name,
    required this.reservDate,
    required this.reservTime,
    required this.status,
    required this.roomName,
    required this.paymentMethod,
    required this.facilityId,
    required this.roomId,
  });

  @override
  List<Object?> get props => [
    id,
    orderNumber,
    userId,
    name,
    reservDate,
    reservTime,
    status,
    roomName,
    paymentMethod,
    facilityId,
    roomId,
  ];
}
