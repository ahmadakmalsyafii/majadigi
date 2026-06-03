import 'package:equatable/equatable.dart';
import 'package:majadigi/deffered_feature/destinasi_wisata/domain/entity/destination_entity.dart';

abstract class DestinationState extends Equatable {
  const DestinationState();

  @override
  List<Object> get props => [];
}

class DestinationInitial extends DestinationState {}

class DestinationLoading extends DestinationState {}

class DestinationLoaded extends DestinationState {
  final List<DestinationEntity> destinations;
  final List<String> availableCategories;

  const DestinationLoaded({
    required this.destinations,
    required this.availableCategories,
  });

  @override
  List<Object> get props => [destinations, availableCategories];
}

class DestinationError extends DestinationState {
  final String message;

  const DestinationError(this.message);

  @override
  List<Object> get props => [message];
}
