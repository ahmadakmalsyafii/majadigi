import 'package:equatable/equatable.dart';
import 'package:majadigi/deffered_feature/no_darurat/domain/entity/emergency_number_entity.dart';
import 'package:majadigi/deffered_feature/no_darurat/domain/entity/kab_kota_entity.dart';

abstract class EmergencyState extends Equatable {
  final int tabIndex;
  final String? selectedKabKotaId;
  final String selectedKabKotaNama;
  final List<KabKotaEntity> kabKotaList;

  const EmergencyState({
    this.tabIndex = 0,
    this.selectedKabKotaId,
    this.selectedKabKotaNama = 'Semua Kota',
    this.kabKotaList = const [],
  });

  @override
  List<Object?> get props =>
      [tabIndex, selectedKabKotaId, selectedKabKotaNama, kabKotaList];
}

class EmergencyInitial extends EmergencyState {
  const EmergencyInitial({
    super.tabIndex,
    super.selectedKabKotaId,
    super.selectedKabKotaNama,
    super.kabKotaList,
  });
}

class EmergencyLoading extends EmergencyState {
  const EmergencyLoading({
    super.tabIndex,
    super.selectedKabKotaId,
    super.selectedKabKotaNama,
    super.kabKotaList,
  });
}

class EmergencyLoaded extends EmergencyState {
  final List<EmergencyNumberEntity> numbers;

  const EmergencyLoaded({
    required this.numbers,
    super.tabIndex,
    super.selectedKabKotaId,
    super.selectedKabKotaNama,
    super.kabKotaList,
  });

  @override
  List<Object?> get props =>
      [numbers, tabIndex, selectedKabKotaId, selectedKabKotaNama, kabKotaList];
}

class EmergencyError extends EmergencyState {
  final String message;

  const EmergencyError({
    required this.message,
    super.tabIndex,
    super.selectedKabKotaId,
    super.selectedKabKotaNama,
    super.kabKotaList,
  });

  @override
  List<Object?> get props =>
      [message, tabIndex, selectedKabKotaId, selectedKabKotaNama, kabKotaList];
}
