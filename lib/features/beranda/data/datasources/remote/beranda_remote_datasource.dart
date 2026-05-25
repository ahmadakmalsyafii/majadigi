import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/core/network/dio_client.dart';
import 'package:majadigi/features/beranda/data/model/banner_model.dart';
import 'package:majadigi/features/beranda/data/model/service_model.dart';
import 'package:majadigi/features/beranda/data/model/jatim_angka_model.dart';

abstract class BerandaRemoteDatasource {
  Future<List<BannerModel>> getAllBanner();
  Future<List<ServiceModel>> getAllService();
  Future<List<ServiceModel>> getServiceSection();
  Future<List<JatimAngkaModel>> getJatimAngka();
}

class BerandaRemoteDatasourceImpl implements BerandaRemoteDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DioClient _dioClient;

  BerandaRemoteDatasourceImpl({required DioClient dioClient})
    : _dioClient = dioClient;

  @override
  Future<List<BannerModel>> getAllBanner() async {
    try {
      final banners = await _firestore
          .collection('banners')
          .where('isActive', isEqualTo: true)
          .get();
      return banners.docs.map((doc) => BannerModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<List<ServiceModel>> getAllService() async {
    try {
      final services = await _firestore.collection('services').get();
      return services.docs
          .map((doc) => ServiceModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }


  @override
  Future<List<ServiceModel>> getServiceSection() async {
    try {
      final services = await _firestore.collection('services').limit(8).get();
      return services.docs
          .map((doc) => ServiceModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<List<JatimAngkaModel>> getJatimAngka() async {
    try {
      final response = await _dioClient.dio.get(
        'https://api.majadigi.jatimprov.go.id/api/public/jatim-angka',
        queryParameters: {
            'page': 1,
            'limit': 3,
        }
      );
      if (response.statusCode == 200 && response.data['data'] != null) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => JatimAngkaModel.fromJson(json)).toList();
      } else {
        throw ServerFailure();
      }
    } on DioException catch (e) {
      throw ServerFailure(message: e.message ?? 'Unknown error occurred');
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}
