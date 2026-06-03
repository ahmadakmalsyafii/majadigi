
import 'package:equatable/equatable.dart';
import 'package:majadigi/features/beranda/domain/entity/service_entity.dart';

abstract class ListLayananState extends Equatable{
  const ListLayananState();

  @override
  List<Object?> get props => [];
}

class ListLayananInitial extends ListLayananState {
  const ListLayananInitial();
}

class ListLayananLoading extends ListLayananState {
  const ListLayananLoading();
}

class ListLayananLoaded extends ListLayananState {
  final List<ServiceEntity> services;
  final List<ServiceEntity> filteredServices;

  const ListLayananLoaded({
    required this.services,
    required this.filteredServices,
  });

  @override
  List<Object?> get props => [services, filteredServices];
}

class ListLayananError extends ListLayananState {
  final String message;

  const ListLayananError({required this.message});

  @override
  List<Object?> get props => [message];
}