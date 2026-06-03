import 'package:equatable/equatable.dart';
import 'package:majadigi/deffered_feature/islamic_center/domain/entity/facility_entity.dart';

abstract class IslamicCenterState extends Equatable {
  const IslamicCenterState();

  @override
  List<Object?> get props => [];
}

class IslamicCenterInitial extends IslamicCenterState {}

class IslamicCenterLoading extends IslamicCenterState {}

class IslamicCenterLoaded extends IslamicCenterState {
  final List<FacilityEntity> facilities;

  const IslamicCenterLoaded({required this.facilities});

  @override
  List<Object?> get props => [facilities];
}

class IslamicCenterError extends IslamicCenterState {
  final String message;

  const IslamicCenterError({required this.message});

  @override
  List<Object?> get props => [message];
}
