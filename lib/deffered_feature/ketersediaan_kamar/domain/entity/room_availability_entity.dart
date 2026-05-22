import 'package:equatable/equatable.dart';

class RoomAvailabilityEntity extends Equatable {
  final RoomSummaryEntity summary;
  final List<RoomDetailEntity> rooms;

  const RoomAvailabilityEntity({required this.summary, required this.rooms});

  @override
  List<Object?> get props => [summary, rooms];
}

class RoomSummaryEntity extends Equatable {
  final int total;
  final int occupied;
  final int available;
  final String lastUpdate;

  const RoomSummaryEntity({
    required this.total,
    required this.occupied,
    required this.available,
    required this.lastUpdate,
  });

  @override
  List<Object?> get props => [total, occupied, available, lastUpdate];
}

class RoomDetailEntity extends Equatable {
  final String name;
  final String type;
  final int total;
  final int occupied;
  final int available;

  const RoomDetailEntity({
    required this.name,
    required this.type,
    required this.total,
    required this.occupied,
    required this.available,
  });

  @override
  List<Object?> get props => [name, type, total, occupied, available];
}
