import 'package:majadigi/deffered_feature/klinik_hoaks/domain/entity/klinik_hoaks_clarification_entity.dart';

class KlinikHoaksClarificationModel extends KlinikHoaksClarificationEntity {
  const KlinikHoaksClarificationModel({
    required super.id,
    required super.judul,
    required super.tanggal,
    required super.isi,
    required super.kategori,
    required super.slugPath,
    required super.image,
    required super.sumber,
  });

  factory KlinikHoaksClarificationModel.fromJson(Map<String, dynamic> json) {
    return KlinikHoaksClarificationModel(
      id: json['id'] ?? 0,
      judul: json['judul'] ?? '',
      tanggal: json['tanggal'] ?? '',
      isi: json['isi'] ?? '',
      kategori: json['kategori'] ?? '',
      slugPath: json['slug_path'] ?? '',
      image: json['image'] ?? '',
      sumber: json['sumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'tanggal': tanggal,
      'isi': isi,
      'kategori': kategori,
      'slug_path': slugPath,
      'image': image,
      'sumber': sumber,
    };
  }
}
