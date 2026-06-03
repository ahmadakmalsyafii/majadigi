import 'package:equatable/equatable.dart';

class BansosEntity extends Equatable {
  final String bankNumber;
  final String category;
  final String city;
  final String name;
  final String nik;
  final String pencairanBerikutnya;
  final String pencairanTerakhir;
  final String totalBantuan;
  final String lastUpdated;

  const BansosEntity({
    required this.bankNumber,
    required this.category,
    required this.city,
    required this.name,
    required this.nik,
    required this.pencairanBerikutnya,
    required this.pencairanTerakhir,
    required this.totalBantuan,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
        bankNumber,
        category,
        city,
        name,
        nik,
        pencairanBerikutnya,
        pencairanTerakhir,
        totalBantuan,
        lastUpdated,
      ];
}
