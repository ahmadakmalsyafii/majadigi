import 'package:equatable/equatable.dart';

class KlinikHoaksClarificationEntity extends Equatable {
  final int id;
  final String judul;
  final String tanggal;
  final String isi;
  final String kategori;
  final String slugPath;
  final String image;
  final String sumber;

  const KlinikHoaksClarificationEntity({
    required this.id,
    required this.judul,
    required this.tanggal,
    required this.isi,
    required this.kategori,
    required this.slugPath,
    required this.image,
    required this.sumber,
  });

  @override
  List<Object?> get props => [
        id,
        judul,
        tanggal,
        isi,
        kategori,
        slugPath,
        image,
        sumber,
      ];
}
