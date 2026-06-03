import 'package:equatable/equatable.dart';

class PendaftaranDokterEntity extends Equatable {
  final String id;
  final String name;
  final String spesialis;
  final String jadwal;
  final int kuota;
  final List<String> availableTimes;
  final String poliId;
  final String hospitalId;

  const PendaftaranDokterEntity({
    required this.id,
    required this.name,
    required this.spesialis,
    required this.jadwal,
    required this.kuota,
    required this.availableTimes,
    required this.poliId,
    required this.hospitalId,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        spesialis,
        jadwal,
        kuota,
        availableTimes,
        poliId,
        hospitalId,
      ];
}
