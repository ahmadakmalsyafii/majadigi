import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:majadigi/deffered_feature/islamic_center/data/model/islamic_center_ticket_model.dart';
import 'package:majadigi/deffered_feature/islamic_center/domain/entity/islamic_center_ticket_entity.dart';
import 'package:majadigi/deffered_feature/islamic_center/domain/repositories/islamic_center_ticket_repository.dart';

@LazySingleton(as: IslamicCenterTicketRepository)
class IslamicCenterTicketRepositoryImpl implements IslamicCenterTicketRepository {
  final FirebaseFirestore _firestore;

  IslamicCenterTicketRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<Either<String, IslamicCenterTicketEntity>> createTicket({
    required String userId,
    required String name,
    required String reservDate,
    required String reservTime,
    required String roomName,
    required String paymentMethod,
    required String facilityId,
    required String roomId,
  }) async {
    try {
      final collection = _firestore.collection('ticket_islamic');

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

      final docRef = collection.doc();

      final model = IslamicCenterTicketModel(
        id: docRef.id,
        orderNumber: nextOrderNumber,
        userId: userId,
        name: name,
        reservDate: reservDate,
        reservTime: reservTime,
        status: 'pending',
        roomName: roomName,
        paymentMethod: paymentMethod,
        facilityId: facilityId,
        roomId: roomId,
      );

      await docRef.set(model.toFirestore());

      return Right(model);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
