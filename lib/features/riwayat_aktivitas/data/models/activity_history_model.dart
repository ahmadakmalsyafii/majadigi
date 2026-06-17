import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/activity_history_entity.dart';

class ActivityHistoryModel extends ActivityHistoryEntity {
  const ActivityHistoryModel({
    required super.id,
    required super.ticketId,
    required super.type,
    required super.title,
    required super.userId,
    required super.status,
    required super.dateBooked,
  });

  factory ActivityHistoryModel.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate = DateTime.now();
    if (json['date_booked'] != null) {
      if (json['date_booked'] is Timestamp) {
        parsedDate = (json['date_booked'] as Timestamp).toDate();
      } else if (json['date_booked'] is String) {
        parsedDate = DateTime.tryParse(json['date_booked']) ?? DateTime.now();
      }
    }

    return ActivityHistoryModel(
      id: json['id'] ?? '',
      ticketId: json['ticket_id'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      userId: json['user_id'] ?? '',
      status: json['status'] ?? '',
      dateBooked: parsedDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ticket_id': ticketId,
      'type': type,
      'title': title,
      'user_id': userId,
      'status': status,
      'date_booked': Timestamp.fromDate(dateBooked),
    };
  }

  factory ActivityHistoryModel.fromEntity(ActivityHistoryEntity entity) {
    return ActivityHistoryModel(
      id: entity.id,
      ticketId: entity.ticketId,
      type: entity.type,
      title: entity.title,
      userId: entity.userId,
      status: entity.status,
      dateBooked: entity.dateBooked,
    );
  }
}
