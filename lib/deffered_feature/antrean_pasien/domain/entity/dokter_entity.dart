import 'package:equatable/equatable.dart';

class DokterEntity extends Equatable {
  final String poliId;
  final String label;
  final String value;

  const DokterEntity({
    required this.poliId,
    required this.label,
    required this.value,
  });

  @override
  List<Object?> get props => [poliId, label, value];
}
