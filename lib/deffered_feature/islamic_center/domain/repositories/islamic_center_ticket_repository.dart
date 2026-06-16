import 'package:dartz/dartz.dart';
import 'package:majadigi/deffered_feature/islamic_center/domain/entity/islamic_center_ticket_entity.dart';

abstract class IslamicCenterTicketRepository {
  Future<Either<String, IslamicCenterTicketEntity>> createTicket({
    required String userId,
    required String name,
    required String reservDate,
    required String reservTime,
    required String roomName,
    required String paymentMethod,
    required String facilityId,
    required String roomId,
  });
}
