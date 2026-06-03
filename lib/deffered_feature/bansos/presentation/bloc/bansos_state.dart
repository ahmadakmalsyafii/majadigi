import 'package:equatable/equatable.dart';
import 'package:majadigi/deffered_feature/bansos/domain/entity/bansos_entity.dart';

abstract class BansosState extends Equatable {
  const BansosState();

  @override
  List<Object> get props => [];
}

class BansosInitial extends BansosState {}

class BansosLoading extends BansosState {}

class BansosLoaded extends BansosState {
  final BansosEntity bansos;

  const BansosLoaded(this.bansos);

  @override
  List<Object> get props => [bansos];
}

class BansosNotFound extends BansosState {}

class BansosError extends BansosState {
  final String message;

  const BansosError(this.message);

  @override
  List<Object> get props => [message];
}
