import 'package:dio/dio.dart';
import 'package:majadigi/core/error/exceptions.dart';
import 'package:majadigi/core/network/dio_client.dart';
import 'package:majadigi/deffered_feature/antrean_pasien/data/model/antrean_model.dart';
import 'package:majadigi/deffered_feature/antrean_pasien/data/model/dokter_model.dart';
import 'package:majadigi/deffered_feature/antrean_pasien/data/model/poli_model.dart';

abstract class AntreanRemoteDataSource {
  Future<List<PoliModel>> getPoliList();
  Future<List<DokterModel>> getDokterList(String poliId);
  Future<AntreanModel> getAntreanStatus(String poliId, String doctorId);
}

class AntreanRemoteDataSourceImpl implements AntreanRemoteDataSource {
  final DioClient dioClient;
  static const _baseUrl = 'https://api-splp.layanan.go.id';

  AntreanRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<PoliModel>> getPoliList() async {
    try {
      final response = await dioClient.dio.get(
        '$_baseUrl/t/jatimprov.go.id/kominfo/transformer/v1/rsud-daha-husada/master/polychlinic',
      );
      if (response.statusCode == 200 && response.data['data'] != null) {
        final List data = response.data['data'];
        return data.map((json) => PoliModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Gagal mengambil data poli');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Gagal menghubungi server');
    } catch (e) {
      throw ServerException(message: 'Terjadi kesalahan sistem.');
    }
  }

  @override
  Future<List<DokterModel>> getDokterList(String poliId) async {
    try {
      final response = await dioClient.dio.get(
        '$_baseUrl/t/jatimprov.go.id/kominfo/transformer/v1/rsud-daha-husada/master/polychlinic/$poliId/doctor',
      );
      if (response.statusCode == 200 && response.data['data'] != null) {
        final List data = response.data['data'];
        return data.map((json) => DokterModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Gagal mengambil data dokter');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Gagal menghubungi server');
    } catch (e) {
      throw ServerException(message: 'Terjadi kesalahan sistem.');
    }
  }

  @override
  Future<AntreanModel> getAntreanStatus(String poliId, String doctorId) async {
    try {
      final response = await dioClient.dio.get(
        '$_baseUrl/t/jatimprov.go.id/kominfo/transformer/v1/rsud-daha-husada/queue/polychlinic/$poliId/doctor/$doctorId',
      );
      if (response.statusCode == 200 && response.data['data'] != null) {
        return AntreanModel.fromJson(response.data['data']);
      } else {
        throw ServerException(message: 'Gagal mengambil data antrean');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Gagal menghubungi server');
    } catch (e) {
      throw ServerException(message: 'Terjadi kesalahan sistem.');
    }
  }
}
