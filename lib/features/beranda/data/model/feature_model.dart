import 'package:majadigi/features/beranda/domain/entity/feature_entity.dart';

class FeatureModel extends FeatureEntity {
  const FeatureModel({
    required super.id,
    required super.layananId,
    required super.judul,
  });

  factory FeatureModel.fromJson(Map<String, dynamic> json) {
    return FeatureModel(
      id: json['id'] ?? '',
      layananId: json['layanan_id'] ?? '',
      judul: json['judul'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'layanan_id': layananId,
      'judul': judul,
    };
  }
}