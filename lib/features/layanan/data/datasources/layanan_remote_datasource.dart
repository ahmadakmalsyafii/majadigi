import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:majadigi/core/error/exceptions.dart';
import 'package:majadigi/core/network/dio_client.dart';
import 'package:majadigi/core/config/app_config.dart';
import 'package:majadigi/features/layanan/data/models/layanan_model.dart';

abstract class LayananRemoteDataSource {
  Future<List<LayananModel>> getKatalogLayanan();
}

@LazySingleton(as: LayananRemoteDataSource)
class LayananRemoteDataSourceImpl implements LayananRemoteDataSource {
  final DioClient _dioClient;

  LayananRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<LayananModel>> getKatalogLayanan() async {
    try {
      final response = await _dioClient.dio.get('${AppConfig.baseUrlMajadigi}/api/public/katalog-layanan');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data.containsKey('data')) {
          final List dynamicList = data['data'];
          return dynamicList.map((item) => LayananModel.fromJson(item)).toList();
        } else {
          throw ServerException(message: 'Invalid response format');
        }
      } else {
        throw ServerException(message: 'Failed to fetch layanan');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Unknown Dio error');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
