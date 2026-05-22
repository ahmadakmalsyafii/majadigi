import 'package:majadigi/deffered_feature/antrean_pasien/domain/entity/antrean_entity.dart';

class AntreanModel extends AntreanEntity {
  const AntreanModel({
    required super.lastUpdate,
    required super.total,
    required super.served,
    required super.time,
    required super.date,
    required super.doctor,
    required super.polyclinic,
  });

  factory AntreanModel.fromJson(Map<String, dynamic> json) {
    int parseIntStr(dynamic val) {
      if (val is int) return val;
      if (val is String) return int.tryParse(val) ?? 0;
      return 0;
    }

    return AntreanModel(
      lastUpdate: json['last_update'] ?? '',
      total: parseIntStr(json['total']),
      served: parseIntStr(json['served']),
      time: json['time'] ?? '',
      date: json['date'] ?? '',
      doctor: json['doctor'] ?? '',
      polyclinic: json['polyclinic'] ?? '',
    );
  }
}
