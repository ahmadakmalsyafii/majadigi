import 'package:equatable/equatable.dart';
import 'package:majadigi/features/beranda/domain/entity/service_entity.dart';
import 'package:majadigi/features/layanan/domain/entities/layanan_entity.dart';

abstract class LayananState extends Equatable {
  const LayananState();
  
  @override
  List<Object?> get props => [];
}

class LayananInitial extends LayananState {}

class LayananLoading extends LayananState {}

class LayananLoaded extends LayananState {
  final List<ServiceEntity> services;
  final List<ServiceEntity> filteredServices;
  final List<LayananEntity> katalogLayanan;
  final List<LayananEntity> filteredKatalogLayanan;

  const LayananLoaded({
    required this.services,
    required this.filteredServices,
    required this.katalogLayanan,
    required this.filteredKatalogLayanan,
  });

  @override
  List<Object?> get props => [
        services,
        filteredServices,
        katalogLayanan,
        filteredKatalogLayanan,
      ];
}

class LayananError extends LayananState {
  final String message;

  const LayananError(this.message);

  @override
  List<Object?> get props => [message];
}
