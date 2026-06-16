
import 'package:equatable/equatable.dart';

class OperationalHourEntity extends Equatable {
  final String hari;
  final String? buka;
  final String? tutup;
  final String? keterangan;

  const OperationalHourEntity({
    required this.hari,
    required this.buka,
    required this.tutup,
    this.keterangan,
  });

  @override
  List<Object?> get props => [hari, buka, tutup, keterangan];

}