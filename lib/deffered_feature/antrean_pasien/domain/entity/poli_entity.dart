import 'package:equatable/equatable.dart';

class PoliEntity extends Equatable {
  final String label;
  final String value;

  const PoliEntity({required this.label, required this.value});

  @override
  List<Object?> get props => [label, value];
}
