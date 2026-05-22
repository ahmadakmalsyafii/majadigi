import 'package:majadigi/deffered_feature/ketersediaan_kamar/domain/entity/room_availability_entity.dart';

class RoomAvailabilityModel extends RoomAvailabilityEntity {
  const RoomAvailabilityModel({
    required super.summary,
    required super.rooms,
  });

  factory RoomAvailabilityModel.fromJson(Map<String, dynamic> json) {
    var dataJson = json['data'] ?? {};
    var list = dataJson['rooms'] as List? ?? [];
    List<RoomDetailModel> roomList = list.map((i) => RoomDetailModel.fromJson(i)).toList();

    return RoomAvailabilityModel(
      summary: RoomSummaryModel.fromJson(dataJson['summary'] ?? {}),
      rooms: roomList,
    );
  }
}

class RoomSummaryModel extends RoomSummaryEntity {
  const RoomSummaryModel({
    required super.total,
    required super.occupied,
    required super.available,
    required super.lastUpdate,
  });

  factory RoomSummaryModel.fromJson(Map<String, dynamic> json) {
    return RoomSummaryModel(
      total: json['total'] ?? 0,
      occupied: json['occupied'] ?? 0,
      available: json['available'] ?? 0,
      lastUpdate: json['last_update'] ?? '-',
    );
  }
}

class RoomDetailModel extends RoomDetailEntity {
  const RoomDetailModel({
    required super.name,
    required super.type,
    required super.total,
    required super.occupied,
    required super.available,
  });

  factory RoomDetailModel.fromJson(Map<String, dynamic> json) {
    return RoomDetailModel(
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      total: json['total'] ?? 0,
      occupied: json['occupied'] ?? 0,
      available: json['available'] ?? 0,
    );
  }
}
