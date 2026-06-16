import 'package:dartz/dartz.dart';
import 'package:majadigi/deffered_feature/destinasi_wisata/domain/entity/destination_ticket_entity.dart';

abstract class DestinationTicketRepository {
  Future<Either<String, DestinationTicketEntity>> createTicket({
    required String userId,
    required String name,
    required String nik,
    required String date,
    required int totalTicket,
    required String paymentMethod,
    required String destinationId,
    required String destinationName,
    required int priceAmount,
  });
}
