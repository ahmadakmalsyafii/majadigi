import 'package:equatable/equatable.dart';

class ActivityHistoryEntity extends Equatable {
  final String id;
  final String ticketId;
  final String type;
  final String title;
  final String userId;
  final String status;
  final DateTime dateBooked;

  const ActivityHistoryEntity({
    required this.id,
    required this.ticketId,
    required this.type,
    required this.title,
    required this.userId,
    required this.status,
    required this.dateBooked,
  });

  @override
  List<Object?> get props => [
    id,
    ticketId,
    type,
    title,
    userId,
    status,
    dateBooked,
  ];
}
