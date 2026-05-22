import 'package:equatable/equatable.dart';

abstract class KetersediaanKamarEvent extends Equatable {
  const KetersediaanKamarEvent();

  @override
  List<Object?> get props => [];
}

class FetchRoomAvailability extends KetersediaanKamarEvent {
  final String hospitalName;

  const FetchRoomAvailability(this.hospitalName);

  @override
  List<Object?> get props => [hospitalName];
}
