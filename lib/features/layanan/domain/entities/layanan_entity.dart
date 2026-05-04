import 'package:equatable/equatable.dart';

class LayananEntity extends Equatable {
  final String id;
  final String nama;
  final String icon;
  final String slug;
  final String? deskripsiSingkat;

  const LayananEntity({
    required this.id,
    required this.nama,
    required this.icon,
    required this.slug,
    this.deskripsiSingkat,
  });

  @override
  List<Object?> get props => [id, nama, icon, slug, deskripsiSingkat];
}
