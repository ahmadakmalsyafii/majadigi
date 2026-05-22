import 'package:majadigi/deffered_feature/antrean_pasien/domain/entity/dokter_entity.dart';

class DokterModel extends DokterEntity {
  const DokterModel({
    required super.poliId,
    required super.label,
    required super.value,
  });

  factory DokterModel.fromJson(Map<String, dynamic> json) {
    return DokterModel(
      poliId: json['poli_id'] ?? '',
      label: json['label'] ?? '',
      value: json['value'] ?? '',
    );
  }
}
