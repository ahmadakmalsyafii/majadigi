import 'package:majadigi/features/beranda/domain/entity/operational_hour_entity.dart';

class OperationalHourModel extends OperationalHourEntity {
  const OperationalHourModel({
    required super.hari,
    required super.buka,
    required super.tutup,
    super.keterangan,
  });

  factory OperationalHourModel.fromJson(Map<String, dynamic> json) {
    return OperationalHourModel(
      hari: json['hari'] ?? '',
      buka: json['buka'],
      tutup: json['tutup'],
      keterangan: json['keterangan'],
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
