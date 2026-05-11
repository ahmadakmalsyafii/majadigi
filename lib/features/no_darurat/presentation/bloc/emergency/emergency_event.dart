import 'package:equatable/equatable.dart';

abstract class EmergencyEvent extends Equatable {
  const EmergencyEvent();

  @override
  List<Object?> get props => [];
}

/// Load awal: fetch kab-kota + nomor darurat (semua kota).
class LoadEmergencyData extends EmergencyEvent {
  const LoadEmergencyData();
}

/// Beralih antara tab "Tentang" (0) dan "Layanan" (1).
class ChangeTab extends EmergencyEvent {
  final int index;
  const ChangeTab(this.index);

  @override
  List<Object?> get props => [index];
}

/// Pilih kab/kota dan fetch ulang nomor darurat sesuai filter.
class SelectCity extends EmergencyEvent {
  final String? kabKotaId; // null = tampilkan semua
  final String kabKotaNama;

  const SelectCity({required this.kabKotaId, required this.kabKotaNama});

  @override
  List<Object?> get props => [kabKotaId, kabKotaNama];
}
