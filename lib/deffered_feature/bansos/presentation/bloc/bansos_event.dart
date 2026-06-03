import 'package:equatable/equatable.dart';

abstract class BansosEvent extends Equatable {
  const BansosEvent();

  @override
  List<Object> get props => [];
}

class SearchBansosEvent extends BansosEvent {
  final String nik;

  const SearchBansosEvent(this.nik);

  @override
  List<Object> get props => [nik];
}
