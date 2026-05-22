import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/deffered_feature/ketersediaan_kamar/domain/entity/room_availability_entity.dart';
import 'package:majadigi/deffered_feature/ketersediaan_kamar/domain/repositories/ketersediaan_kamar_repository.dart';

class GetRoomAvailabilityUseCase {
  final KetersediaanKamarRepository repository;

  GetRoomAvailabilityUseCase(this.repository);

  Future<Either<Failure, RoomAvailabilityEntity>> call(String hospitalName) async {
    return await repository.getRoomAvailability(hospitalName);
  }
}
