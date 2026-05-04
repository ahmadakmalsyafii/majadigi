import 'package:majadigi/features/layanan/domain/entities/layanan_entity.dart';

class LayananModel extends LayananEntity {
  const LayananModel({
    required super.id,
    required super.nama,
    required super.icon,
    required super.slug,
    super.deskripsiSingkat,
  });

  factory LayananModel.fromJson(Map<String, dynamic> json) {
    return LayananModel(
      id: json['id'] ?? '',
      nama: json['nama'] ?? '',
      icon: json['icon'] ?? '',
      slug: json['slug'] ?? '',
      deskripsiSingkat: json['deskripsi_singkat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'icon': icon,
      'slug': slug,
      'deskripsi_singkat': deskripsiSingkat,
    };
  }
}
