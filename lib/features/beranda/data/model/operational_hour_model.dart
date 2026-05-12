import 'package:majadigi/features/beranda/domain/entity/operational_hour_entity.dart';

class OperationalHourModel extends OperationalHourEntity {
  const OperationalHourModel({
    required super.hari,
    required super.buka,
    required super.tutup,
    super.keterangan,
  });

  factory OperationalHourModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('items') && json['items'] is List && (json['items'] as List).isNotEmpty) {
      final firstItem = json['items'][0] as Map;
      return OperationalHourModel(
        hari: firstItem['hari'] ?? '',
        buka: firstItem['buka'] ?? '',
        tutup: firstItem['tutup'] ?? '',
        keterangan: firstItem['keterangan'] ?? '',
      );
    }
    return const OperationalHourModel(
      hari: '',
      buka: '',
      tutup: '',
      keterangan: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hari': hari,
      'buka': buka,
      'tutup': tutup,
      'keterangan': keterangan,
    };
  }
}
