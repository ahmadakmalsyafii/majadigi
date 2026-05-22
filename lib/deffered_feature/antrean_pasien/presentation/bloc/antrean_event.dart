import 'package:equatable/equatable.dart';
import 'package:majadigi/deffered_feature/antrean_pasien/domain/entity/poli_entity.dart';
import 'package:majadigi/deffered_feature/antrean_pasien/domain/entity/dokter_entity.dart';

abstract class AntreanEvent extends Equatable {
  const AntreanEvent();
  @override
  List<Object?> get props => [];
}

class FetchPoliEvent extends AntreanEvent {}

class FetchDokterEvent extends AntreanEvent {
  final PoliEntity selectedPoli;
  const FetchDokterEvent(this.selectedPoli);
  @override
  List<Object?> get props => [selectedPoli];
}

class SelectDokterEvent extends AntreanEvent {
  final DokterEntity selectedDokter;
  const SelectDokterEvent(this.selectedDokter);
  @override
  List<Object?> get props => [selectedDokter];
}

class CekAntreanEvent extends AntreanEvent {}
