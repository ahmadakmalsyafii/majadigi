
import 'package:equatable/equatable.dart';

abstract class ListLayananEvent extends Equatable{

  const ListLayananEvent();

  @override
  List<Object?> get props => [];
}


class GetListLayananEvent extends ListLayananEvent {
  const GetListLayananEvent();
}

class SearchListLayananEvent extends ListLayananEvent {
  final String query;

  const SearchListLayananEvent(this.query);

  @override
  List<Object?> get props => [query];
}