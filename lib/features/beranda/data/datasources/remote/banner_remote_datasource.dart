
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/features/beranda/data/model/banner_model.dart';
import 'package:majadigi/features/beranda/domain/entitiy/banner_entity.dart';

abstract class BannerRemoteDataSource {
  Future<List<BannerModel>> getAllBanners();
}

class BannerRemoteDataSourceImpl implements BannerRemoteDataSource {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<BannerModel>> getAllBanners() async {
    try {
      final banners = await _firestore
          .collection('banners')
          .where('isActive', isEqualTo: true)
          .get();
      return banners.docs.map((doc) => BannerModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw ServerFailure();
    }
  }
}