import 'package:equatable/equatable.dart';

class AntreanEntity extends Equatable {
  final String lastUpdate;
  final int total;
  final int served;
  final String time;
  final String date;
  final String doctor;
  final String polyclinic;

  const AntreanEntity({
    required this.lastUpdate,
    required this.total,
    required this.served,
    required this.time,
    required this.date,
    required this.doctor,
    required this.polyclinic,
  });

  @override
  List<Object?> get props => [
        lastUpdate,
        total,
        served,
        time,
        date,
        doctor,
        polyclinic,
      ];
}
