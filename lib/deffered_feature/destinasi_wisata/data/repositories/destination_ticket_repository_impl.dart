import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:majadigi/deffered_feature/destinasi_wisata/data/model/destination_ticket_model.dart';
import 'package:majadigi/deffered_feature/destinasi_wisata/domain/entity/destination_ticket_entity.dart';
import 'package:majadigi/deffered_feature/destinasi_wisata/domain/repositories/destination_ticket_repository.dart';

@LazySingleton(as: DestinationTicketRepository)
class DestinationTicketRepositoryImpl implements DestinationTicketRepository {
  final FirebaseFirestore _firestore;

  DestinationTicketRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
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
  }) async {
    try {
      final collection = _firestore.collection('ticket_destination');
      
      // Get next order number (simple approach)
      final querySnapshot = await collection
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();
          
      int nextOrderNumber = 1;
      if (querySnapshot.docs.isNotEmpty) {
        final lastData = querySnapshot.docs.first.data();
        final lastOrderNumber = lastData['orderNumber'] as int? ?? 0;
        nextOrderNumber = lastOrderNumber + 1;
      }

      // Generate reference for auto-id
      final docRef = collection.doc();

      final model = DestinationTicketModel(
        id: docRef.id,
        orderNumber: nextOrderNumber,
        userId: userId,
        name: name,
        nik: nik,
        date: date,
        totalTicket: totalTicket,
        paymentMethod: paymentMethod,
        destinationId: destinationId,
        destinationName: destinationName,
        priceAmount: priceAmount,
        status: 'pending',
      );

      await docRef.set(model.toFirestore());

      return Right(model);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
