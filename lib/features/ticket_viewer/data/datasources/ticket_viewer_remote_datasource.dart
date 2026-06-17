import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

abstract class TicketViewerRemoteDataSource {
  Future<Map<String, dynamic>> getTicketData(String ticketId, String type);
}

@LazySingleton(as: TicketViewerRemoteDataSource)
class TicketViewerRemoteDataSourceImpl implements TicketViewerRemoteDataSource {
  final FirebaseFirestore firestore;

  TicketViewerRemoteDataSourceImpl({FirebaseFirestore? firestore}) : firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<Map<String, dynamic>> getTicketData(String ticketId, String type) async {
    String collectionName;
    if (type == 'islamic_center') {
      collectionName = 'ticket_islamic';
    } else if (type == 'destinasi_wisata') {
      collectionName = 'ticket_destination';
    } else {
      throw Exception('Unknown ticket type: $type');
    }

    final docSnapshot = await firestore.collection(collectionName).doc(ticketId).get();

    if (!docSnapshot.exists || docSnapshot.data() == null) {
      throw Exception('Ticket not found');
    }

    final data = docSnapshot.data()!;
    data['id'] = docSnapshot.id;
    data['type'] = type;
    
    return data;
  }
}
