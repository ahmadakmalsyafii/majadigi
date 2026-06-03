import 'package:majadigi/deffered_feature/islamic_center/domain/entity/facility_entity.dart';

class RoomModel extends RoomEntity {
  const RoomModel({
    required super.roomId,
    required super.name,
    required super.capacity,
    required super.priceFormatted,
    required super.priceAmount,
    required super.imageUrl,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      roomId: json['room_id'] ?? '',
      name: json['name'] ?? '',
      capacity: json['capacity'] ?? 0,
      priceFormatted: json['price_formatted'] ?? '',
      priceAmount: json['price_amount'] ?? 0,
      imageUrl: json['image_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'room_id': roomId,
      'name': name,
      'capacity': capacity,
      'price_formatted': priceFormatted,
      'price_amount': priceAmount,
      'image_url': imageUrl,
    };
  }
}

class FacilityModel extends FacilityEntity {
  const FacilityModel({
    required super.facilityId,
    required super.name,
    required super.description,
    required super.imageUrl,
    required super.tags,
    required super.rooms,
  });

  factory FacilityModel.fromJson(String id, Map<String, dynamic> json) {
    return FacilityModel(
      facilityId: id,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      rooms: (json['rooms'] as List<dynamic>?)
              ?.map((e) => RoomModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'tags': tags,
      'rooms': rooms.map((e) => (e as RoomModel).toJson()).toList(),
    };
  }
}
