import 'package:equatable/equatable.dart';
import 'package:majadigi/deffered_feature/ketersediaan_kamar/domain/entity/room_availability_entity.dart';

abstract class KetersediaanKamarState extends Equatable {
  const KetersediaanKamarState();

  @override
  List<Object?> get props => [];
}

class KetersediaanKamarInitial extends KetersediaanKamarState {}

class KetersediaanKamarLoading extends KetersediaanKamarState {}

class KetersediaanKamarLoaded extends KetersediaanKamarState {
  final RoomAvailabilityEntity data;

  const KetersediaanKamarLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class KetersediaanKamarError extends KetersediaanKamarState {
  final String message;

  const KetersediaanKamarError(this.message);

  @override
  List<Object?> get props => [message];
}
