import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:majadigi/deffered_feature/islamic_center/domain/entity/islamic_center_ticket_entity.dart';

class IslamicCenterTicketModel extends IslamicCenterTicketEntity {
  const IslamicCenterTicketModel({
    required super.id,
    required super.orderNumber,
    required super.userId,
    required super.name,
    required super.reservDate,
    required super.reservTime,
    required super.status,
    required super.roomName,
    required super.paymentMethod,
    required super.facilityId,
    required super.roomId,
  });

  factory IslamicCenterTicketModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return IslamicCenterTicketModel(
      id: doc.id,
      orderNumber: data['orderNumber'] ?? 0,
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      reservDate: data['reserv_date'] ?? '',
      reservTime: data['reserv_time'] ?? '',
      status: data['status'] ?? 'pending',
      roomName: data['roomName'] ?? '',
      paymentMethod: data['paymentMethod'] ?? '',
      facilityId: data['facilityId'] ?? '',
      roomId: data['roomId'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'orderNumber': orderNumber,
      'userId': userId,
      'name': name,
      'reserv_date': reservDate,
      'reserv_time': reservTime,
      'status': status,
      'roomName': roomName,
      'paymentMethod': paymentMethod,
      'facilityId': facilityId,
      'roomId': roomId,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
