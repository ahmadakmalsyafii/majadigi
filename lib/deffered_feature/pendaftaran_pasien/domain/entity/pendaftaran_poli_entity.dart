import 'package:equatable/equatable.dart';

class PendaftaranPoliEntity extends Equatable {
  final String id;
  final String name;
  final int doctorsCount;
  final int quota;
  final String hospitalId;

  const PendaftaranPoliEntity({
    required this.id,
    required this.name,
    required this.doctorsCount,
    required this.quota,
    required this.hospitalId,
  });

  @override
  List<Object?> get props => [id, name, doctorsCount, quota, hospitalId];
}
