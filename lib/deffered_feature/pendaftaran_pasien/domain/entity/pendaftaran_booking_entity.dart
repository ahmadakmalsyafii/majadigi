import 'package:equatable/equatable.dart';

class PendaftaranBookingEntity extends Equatable {
  final String id;
  final String userId;
  final String patientName;
  final String patientNIK;
  final String hospitalId;
  final String hospitalName;
  final String poliId;
  final String poliName;
  final String doctorId;
  final String doctorName;
  final String date;
  final String time;
  final String queueNumber;
  final DateTime createdAt;

  const PendaftaranBookingEntity({
    required this.id,
    required this.userId,
    required this.patientName,
    required this.patientNIK,
    required this.hospitalId,
    required this.hospitalName,
    required this.poliId,
    required this.poliName,
    required this.doctorId,
    required this.doctorName,
    required this.date,
    required this.time,
    required this.queueNumber,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        patientName,
        patientNIK,
        hospitalId,
        hospitalName,
        poliId,
        poliName,
        doctorId,
        doctorName,
        date,
        time,
        queueNumber,
        createdAt,
      ];
}
