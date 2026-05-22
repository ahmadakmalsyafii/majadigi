import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/deffered_feature/ketersediaan_kamar/domain/entity/room_availability_entity.dart';

abstract class KetersediaanKamarRepository {
  Future<Either<Failure, RoomAvailabilityEntity>> getRoomAvailability(String hospitalName);
}
