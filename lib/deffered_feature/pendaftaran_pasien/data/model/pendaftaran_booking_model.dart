import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/domain/entity/pendaftaran_booking_entity.dart';

class PendaftaranBookingModel extends PendaftaranBookingEntity {
  const PendaftaranBookingModel({
    required super.id,
    required super.userId,
    required super.patientName,
    required super.patientNIK,
    required super.hospitalId,
    required super.hospitalName,
    required super.poliId,
    required super.poliName,
    required super.doctorId,
    required super.doctorName,
    required super.date,
    required super.time,
    required super.queueNumber,
    required super.createdAt,
  });

  factory PendaftaranBookingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PendaftaranBookingModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      patientName: data['patientName'] ?? '',
      patientNIK: data['patientNIK'] ?? '',
      hospitalId: data['hospitalId'] ?? '',
      hospitalName: data['hospitalName'] ?? '',
      poliId: data['poliId'] ?? '',
      poliName: data['poliName'] ?? '',
      doctorId: data['doctorId'] ?? '',
      doctorName: data['doctorName'] ?? '',
      date: data['date'] ?? '',
      time: data['time'] ?? '',
      queueNumber: data['queueNumber'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'patientName': patientName,
      'patientNIK': patientNIK,
      'hospitalId': hospitalId,
      'hospitalName': hospitalName,
      'poliId': poliId,
      'poliName': poliName,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'date': date,
      'time': time,
      'queueNumber': queueNumber,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
