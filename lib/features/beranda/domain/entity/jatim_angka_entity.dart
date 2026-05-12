import 'package:equatable/equatable.dart';

class JatimAngkaEntity extends Equatable {
  final String id;
  final String nama;
  final String tahun;
  final int jumlah;
  final String? satuan;
  final String icon;

  const JatimAngkaEntity({
    required this.id,
    required this.nama,
    required this.tahun,
    required this.jumlah,
    this.satuan,
    required this.icon,
  });

  @override
  List<Object?> get props => [id, nama, tahun, jumlah, satuan, icon];
}
