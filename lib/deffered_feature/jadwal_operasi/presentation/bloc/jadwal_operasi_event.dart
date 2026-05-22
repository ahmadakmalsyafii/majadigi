import 'package:equatable/equatable.dart';

abstract class JadwalOperasiEvent extends Equatable {
  const JadwalOperasiEvent();
  @override
  List<Object?> get props => [];
}

class FetchJadwalOperasiEvent extends JadwalOperasiEvent {
  final String? date;
  final String? surgeryName;

  const FetchJadwalOperasiEvent({this.date, this.surgeryName});

  @override
  List<Object?> get props => [date, surgeryName];
}
