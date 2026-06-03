import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:majadigi/deffered_feature/islamic_center/data/model/facility_model.dart';

abstract class IslamicCenterRemoteDataSource {
  Future<List<FacilityModel>> getFacilities();
}

class IslamicCenterRemoteDataSourceImpl implements IslamicCenterRemoteDataSource {
  final FirebaseFirestore firestore;

  IslamicCenterRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<FacilityModel>> getFacilities() async {
    try {
      final snapshot = await firestore.collection('islamic_center').get();
      return snapshot.docs.map((doc) {
        return FacilityModel.fromJson(doc.id, doc.data());
      }).toList();
    } catch (e) {
      throw Exception('Failed to get islamic center facilities: $e');
    }
  }
}
