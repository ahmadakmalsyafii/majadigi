import 'package:equatable/equatable.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/domain/entity/pendaftaran_poli_entity.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/domain/entity/pendaftaran_dokter_entity.dart';
import 'package:majadigi/features/auth/domain/entity/user_entity.dart';

abstract class PendaftaranEvent extends Equatable {
  const PendaftaranEvent();
  @override
  List<Object?> get props => [];
}

class LoadPolisEvent extends PendaftaranEvent {
  final String hospitalId;
  const LoadPolisEvent(this.hospitalId);
  @override
  List<Object?> get props => [hospitalId];
}

class SelectPoliEvent extends PendaftaranEvent {
  final PendaftaranPoliEntity poli;
  const SelectPoliEvent(this.poli);
  @override
  List<Object?> get props => [poli];
}

class SelectDoctorEvent extends PendaftaranEvent {
  final PendaftaranDokterEntity doctor;
  const SelectDoctorEvent(this.doctor);
  @override
  List<Object?> get props => [doctor];
}

class SelectDateEvent extends PendaftaranEvent {
  final DateTime date;
  const SelectDateEvent(this.date);
  @override
  List<Object?> get props => [date];
}

class SelectTimeEvent extends PendaftaranEvent {
  final String time;
  const SelectTimeEvent(this.time);
  @override
  List<Object?> get props => [time];
}

class SubmitRegistrationEvent extends PendaftaranEvent {
  final UserEntity user;
  final String hospitalName;
  const SubmitRegistrationEvent({required this.user, required this.hospitalName});
  @override
  List<Object?> get props => [user, hospitalName];
}

class PrevStepEvent extends PendaftaranEvent {}

class NextStepEvent extends PendaftaranEvent {}
