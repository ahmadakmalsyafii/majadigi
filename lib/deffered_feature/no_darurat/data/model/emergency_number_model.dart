import 'package:majadigi/deffered_feature/no_darurat/domain/entity/emergency_number_entity.dart';

class EmergencyNumberModel extends EmergencyNumberEntity {
  const EmergencyNumberModel({
    required super.id,
    required super.serviceName,
    required super.number,
    super.kabKotaId,
    super.kabKotaNama,
  });

  factory EmergencyNumberModel.fromJson(Map<String, dynamic> json) {
    return EmergencyNumberModel(
      id: (json['id'] ?? '').toString(),
      serviceName: json['nama'] ?? '',
      number: json['nomor'] ?? '',
      kabKotaId: json['kab_kota_id']?.toString(),
      kabKotaNama: json['kab_kota']?['nama_daerah'],
    );
  }
}
