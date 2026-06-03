import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:majadigi/deffered_feature/bansos/data/model/bansos_model.dart';
import 'package:majadigi/core/error/exceptions.dart';

abstract class BansosRemoteDataSource {
  Future<BansosModel?> getBansosByNik(String nik);
}

class BansosRemoteDataSourceImpl implements BansosRemoteDataSource {
  final FirebaseFirestore firestore;

  BansosRemoteDataSourceImpl({required this.firestore});

  @override
  Future<BansosModel?> getBansosByNik(String nik) async {
    try {
      final querySnapshot = await firestore
          .collection('bansos')
          .where('nik', isEqualTo: nik)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        return BansosModel.fromJson(doc.data());
      }
      return null;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
