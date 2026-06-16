import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:majadigi/deffered_feature/islamic_center/domain/entity/islamic_center_ticket_entity.dart';
import 'package:majadigi/deffered_feature/islamic_center/domain/repositories/islamic_center_ticket_repository.dart';

@lazySingleton
class CreateIslamicTicketUsecase {
  final IslamicCenterTicketRepository repository;

  CreateIslamicTicketUsecase(this.repository);

  Future<Either<String, IslamicCenterTicketEntity>> call({
    required String userId,
    required String name,
    required String reservDate,
    required String reservTime,
    required String roomName,
    required String paymentMethod,
    required String facilityId,
    required String roomId,
  }) async {
    return await repository.createTicket(
      userId: userId,
      name: name,
      reservDate: reservDate,
      reservTime: reservTime,
      roomName: roomName,
      paymentMethod: paymentMethod,
      facilityId: facilityId,
      roomId: roomId,
    );
  }
}
