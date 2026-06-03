import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:majadigi/core/error/exceptions.dart';
import 'package:majadigi/deffered_feature/destinasi_wisata/data/model/destination_model.dart';

abstract class DestinationRemoteDataSource {
  Future<List<DestinationModel>> getDestinations();
}

class DestinationRemoteDataSourceImpl implements DestinationRemoteDataSource {
  final FirebaseFirestore firestore;

  DestinationRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<DestinationModel>> getDestinations() async {
    try {
      final snapshot = await firestore.collection('destinations').get();
      return snapshot.docs
          .map((doc) => DestinationModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw ServerException();
    }
  }
}
