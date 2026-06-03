import 'package:majadigi/deffered_feature/bansos/domain/entity/bansos_entity.dart';

class BansosModel extends BansosEntity {
  const BansosModel({
    required super.bankNumber,
    required super.category,
    required super.city,
    required super.name,
    required super.nik,
    required super.pencairanBerikutnya,
    required super.pencairanTerakhir,
    required super.totalBantuan,
    required super.lastUpdated,
  });

  factory BansosModel.fromJson(Map<String, dynamic> json) {
    return BansosModel(
      bankNumber: json['bank_number'] ?? '',
      category: json['category'] ?? '',
      city: json['city'] ?? '',
      name: json['name'] ?? '',
      nik: json['nik'] ?? '',
      pencairanBerikutnya: json['pencairan_berikutnya'] ?? '',
      pencairanTerakhir: json['pencairan_terakhir'] ?? '',
      totalBantuan: json['total_bantuan'] ?? '',
      lastUpdated: json['last_updated'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bank_number': bankNumber,
      'category': category,
      'city': city,
      'name': name,
      'nik': nik,
      'pencairan_berikutnya': pencairanBerikutnya,
      'pencairan_terakhir': pencairanTerakhir,
      'total_bantuan': totalBantuan,
      'last_updated': lastUpdated,
    };
  }

  BansosEntity toEntity() {
    return BansosEntity(
      bankNumber: bankNumber,
      category: category,
      city: city,
      name: name,
      nik: nik,
      pencairanBerikutnya: pencairanBerikutnya,
      pencairanTerakhir: pencairanTerakhir,
      totalBantuan: totalBantuan,
      lastUpdated: lastUpdated,
    );
  }
}
