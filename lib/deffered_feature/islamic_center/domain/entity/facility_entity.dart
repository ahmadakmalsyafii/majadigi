import 'package:equatable/equatable.dart';

class RoomEntity extends Equatable {
  final String roomId;
  final String name;
  final int capacity;
  final String priceFormatted;
  final int priceAmount;
  final String imageUrl;

  const RoomEntity({
    required this.roomId,
    required this.name,
    required this.capacity,
    required this.priceFormatted,
    required this.priceAmount,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [
        roomId,
        name,
        capacity,
        priceFormatted,
        priceAmount,
        imageUrl,
      ];
}

class FacilityEntity extends Equatable {
  final String facilityId;
  final String name;
  final String description;
  final String imageUrl;
  final List<String> tags;
  final List<RoomEntity> rooms;

  const FacilityEntity({
    required this.facilityId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.tags,
    required this.rooms,
  });

  @override
  List<Object?> get props => [
        facilityId,
        name,
        description,
        imageUrl,
        tags,
        rooms,
      ];
}
