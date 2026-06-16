import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:majadigi/deffered_feature/destinasi_wisata/domain/entity/destination_ticket_entity.dart';
import 'package:majadigi/deffered_feature/destinasi_wisata/domain/repositories/destination_ticket_repository.dart';

@lazySingleton
class CreateDestinationTicketUsecase {
  final DestinationTicketRepository repository;

  CreateDestinationTicketUsecase(this.repository);

  Future<Either<String, DestinationTicketEntity>> call({
    required String userId,
    required String name,
    required String nik,
    required String date,
    required int totalTicket,
    required String paymentMethod,
    required String destinationId,
    required String destinationName,
    required int priceAmount,
  }) async {
    return await repository.createTicket(
      userId: userId,
      name: name,
      nik: nik,
      date: date,
      totalTicket: totalTicket,
      paymentMethod: paymentMethod,
      destinationId: destinationId,
      destinationName: destinationName,
      priceAmount: priceAmount,
    );
  }
}
