import 'package:equatable/equatable.dart';

class JadwalOperasiResponseEntity extends Equatable {
  final SummaryOperasiEntity summary;
  final List<TanggalOperasiEntity> schedules;

  const JadwalOperasiResponseEntity({
    required this.summary,
    required this.schedules,
  });

  @override
  List<Object?> get props => [summary, schedules];
}

class SummaryOperasiEntity extends Equatable {
  final int total;
  final int done;
  final int scheduled;
  final String lastUpdate;

  const SummaryOperasiEntity({
    required this.total,
    required this.done,
    required this.scheduled,
    required this.lastUpdate,
  });

  @override
  List<Object?> get props => [total, done, scheduled, lastUpdate];
}

class TanggalOperasiEntity extends Equatable {
  final String date;
  final List<DetailOperasiEntity> schedules;

  const TanggalOperasiEntity({
    required this.date,
    required this.schedules,
  });

  @override
  List<Object?> get props => [date, schedules];
}

class DetailOperasiEntity extends Equatable {
  final String name;
  final String surgeryId;
  final String doctorName;
  final String poliName;
  final String surgeryName;

  const DetailOperasiEntity({
    required this.name,
    required this.surgeryId,
    required this.doctorName,
    required this.poliName,
    required this.surgeryName,
  });

  @override
  List<Object?> get props => [name, surgeryId, doctorName, poliName, surgeryName];
}
