import 'package:equatable/equatable.dart';

class KabKotaEntity extends Equatable {
  final String id;
  final String nama;

  const KabKotaEntity({
    required this.id,
    required this.nama,
  });

  @override
  List<Object?> get props => [id, nama];
}
