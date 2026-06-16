import 'package:equatable/equatable.dart';

class KetentuanLayananEntity extends Equatable {
  final List<String> manfaat;
  final List<String> sistemMekanismeProsedur;

  const KetentuanLayananEntity({
    required this.manfaat,
    required this.sistemMekanismeProsedur,
  });

  @override
  List<Object?> get props => [manfaat, sistemMekanismeProsedur];
}
