import 'package:majadigi/deffered_feature/antrean_pasien/domain/entity/poli_entity.dart';

class PoliModel extends PoliEntity {
  const PoliModel({
    required super.label,
    required super.value,
  });

  factory PoliModel.fromJson(Map<String, dynamic> json) {
    return PoliModel(
      label: json['label'] ?? '',
      value: json['value'] ?? '',
    );
  }
}
