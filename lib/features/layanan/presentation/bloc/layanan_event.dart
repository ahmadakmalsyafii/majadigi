import 'package:equatable/equatable.dart';

abstract class LayananEvent extends Equatable {
  const LayananEvent();

  @override
  List<Object?> get props => [];
}

class FetchLayananData extends LayananEvent {}

class SearchLayananEvent extends LayananEvent {
  final String query;

  const SearchLayananEvent(this.query);

  @override
  List<Object?> get props => [query];
}
