import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:majadigi/deffered_feature/destinasi_wisata/domain/entity/destination_ticket_entity.dart';

class DestinationTicketModel extends DestinationTicketEntity {
  const DestinationTicketModel({
    required super.id,
    required super.orderNumber,
    required super.userId,
    required super.name,
    required super.nik,
    required super.date,
    required super.totalTicket,
    required super.paymentMethod,
    required super.destinationId,
    required super.destinationName,
    required super.priceAmount,
    required super.status,
  });

  factory DestinationTicketModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return DestinationTicketModel(
      id: doc.id,
      orderNumber: data['orderNumber'] as int? ?? 0,
      userId: data['userId'] as String? ?? '',
      name: data['name'] as String? ?? '',
      nik: data['nik'] as String? ?? '',
      date: data['date'] as String? ?? '',
      totalTicket: data['total_ticket'] as int? ?? 1,
      paymentMethod: data['payment_method'] as String? ?? '',
      destinationId: data['destinationId'] as String? ?? '',
      destinationName: data['destinationName'] as String? ?? '',
      priceAmount: data['priceAmount'] as int? ?? 0,
      status: data['status'] as String? ?? 'pending',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'orderNumber': orderNumber,
      'userId': userId,
      'name': name,
      'nik': nik,
      'date': date,
      'total_ticket': totalTicket,
      'payment_method': paymentMethod,
      'destinationId': destinationId,
      'destinationName': destinationName,
      'priceAmount': priceAmount,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
