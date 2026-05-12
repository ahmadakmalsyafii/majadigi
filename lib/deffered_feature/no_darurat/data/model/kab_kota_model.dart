import 'package:majadigi/deffered_feature/no_darurat/domain/entity/kab_kota_entity.dart';

class KabKotaModel extends KabKotaEntity {
  const KabKotaModel({
    required super.id,
    required super.nama,
  });

  factory KabKotaModel.fromJson(Map<String, dynamic> json) {
    return KabKotaModel(
      id: (json['id'] ?? '').toString(),
      nama: json['nama_daerah'] ?? json['nama'] ?? '',
    );
  }
}
