part of 'islamic_center_ticket_bloc.dart';

abstract class IslamicCenterTicketEvent extends Equatable {
  const IslamicCenterTicketEvent();

  @override
  List<Object?> get props => [];
}

class CreateIslamicCenterTicketEvent extends IslamicCenterTicketEvent {
  final String userId;
  final String name;
  final String reservDate;
  final String reservTime;
  final String roomName;
  final String paymentMethod;
  final String facilityId;
  final String roomId;
  final Completer<void>? completer;

  const CreateIslamicCenterTicketEvent({
    required this.userId,
    required this.name,
    required this.reservDate,
    required this.reservTime,
    required this.roomName,
    required this.paymentMethod,
    required this.facilityId,
    required this.roomId,
    this.completer,
  });

  @override
  List<Object?> get props => [
        userId,
        name,
        reservDate,
        reservTime,
        roomName,
        paymentMethod,
        facilityId,
        roomId,
        completer,
      ];
}
