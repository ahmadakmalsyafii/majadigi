import 'package:majadigi/features/beranda/domain/entity/jatim_angka_entity.dart';

class JatimAngkaModel extends JatimAngkaEntity {
  const JatimAngkaModel({
    required super.id,
    required super.nama,
    required super.tahun,
    required super.jumlah,
    super.satuan,
    required super.icon,
  });

  factory JatimAngkaModel.fromJson(Map<String, dynamic> json) {
    return JatimAngkaModel(
      id: json['id'] ?? '',
      nama: json['nama'] ?? '',
      tahun: json['tahun']?.toString() ?? '',
      jumlah: json['jumlah'] is int ? json['jumlah'] : int.tryParse(json['jumlah'].toString()) ?? 0,
      satuan: json['satuan'],
      icon: json['icon'] ?? '',
    );
  }
}
