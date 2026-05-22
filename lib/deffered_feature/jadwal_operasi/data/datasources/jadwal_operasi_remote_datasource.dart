import 'package:dio/dio.dart';
import 'package:majadigi/core/error/exceptions.dart';
import 'package:majadigi/core/network/dio_client.dart';
import 'package:majadigi/deffered_feature/jadwal_operasi/data/model/jadwal_operasi_model.dart';

abstract class JadwalOperasiRemoteDataSource {
  Future<JadwalOperasiResponseModel> getJadwalOperasi({String? date, String? surgeryName});
}

class JadwalOperasiRemoteDataSourceImpl implements JadwalOperasiRemoteDataSource {
  final DioClient dioClient;

  JadwalOperasiRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<JadwalOperasiResponseModel> getJadwalOperasi({String? date, String? surgeryName}) async {
    try {
      final queryParams = <String, dynamic>{
        'page': 1,
        'limit': 50,
      };

      if (date != null && date.isNotEmpty) {
        queryParams['date[gte]'] = date;
        queryParams['date[lte]'] = date;
      }
      if (surgeryName != null && surgeryName.isNotEmpty) {
        queryParams['search[surgery_name]'] = surgeryName;
      }

      final response = await dioClient.dio.get(
        'https://api-splp.layanan.go.id/t/jatimprov.go.id/kominfo/transformer/v1/rsud-daha-husada/schedule/surgery',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        return JadwalOperasiResponseModel.fromJson(response.data);
      } else {
        throw ServerException(message: 'Gagal mengambil data jadwal operasi');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Gagal menghubungi server');
    } catch (e) {
      throw ServerException(message: 'Terjadi kesalahan sistem.');
    }
  }
}
