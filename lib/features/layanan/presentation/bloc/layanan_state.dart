import 'package:equatable/equatable.dart';
import 'package:majadigi/features/layanan/domain/entities/layanan_entity.dart';

abstract class LayananState extends Equatable {
  const LayananState();
  
  @override
  List<Object?> get props => [];
}

class LayananInitial extends LayananState {}

class LayananLoading extends LayananState {}

class LayananLoaded extends LayananState {
  final List<LayananEntity> layananList;

  const LayananLoaded(this.layananList);

  @override
  List<Object?> get props => [layananList];
}

class LayananError extends LayananState {
  final String message;

  const LayananError(this.message);

  @override
  List<Object?> get props => [message];
}
