import 'package:equatable/equatable.dart';

class EmergencyNumberEntity extends Equatable {
  final String id;
  final String serviceName;
  final String number;
  final String? kabKotaId;
  final String? kabKotaNama;

  const EmergencyNumberEntity({
    required this.id,
    required this.serviceName,
    required this.number,
    this.kabKotaId,
    this.kabKotaNama,
  });

  @override
  List<Object?> get props => [id, serviceName, number, kabKotaId, kabKotaNama];
}
