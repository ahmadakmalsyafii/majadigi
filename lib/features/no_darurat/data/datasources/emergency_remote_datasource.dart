import 'package:dio/dio.dart';
import 'package:majadigi/core/error/exceptions.dart';
import 'package:majadigi/core/network/dio_client.dart';
import 'package:majadigi/core/config/app_config.dart';
import 'package:majadigi/features/no_darurat/data/model/emergency_number_model.dart';
import 'package:majadigi/features/no_darurat/data/model/kab_kota_model.dart';

abstract class EmergencyRemoteDataSource {
  /// Fetch nomor darurat, opsional filter berdasarkan [kabKotaId].
  Future<List<EmergencyNumberModel>> getEmergencyNumbers({
    String? kabKotaId,
  });

  /// Fetch daftar kabupaten/kota untuk dropdown filter.
  Future<List<KabKotaModel>> getKabKota();
}

class EmergencyRemoteDataSourceImpl implements EmergencyRemoteDataSource {
  final DioClient _dioClient;

  EmergencyRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<EmergencyNumberModel>> getEmergencyNumbers({
    String? kabKotaId,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (kabKotaId != null && kabKotaId.isNotEmpty) {
        queryParams['kab_kota_id'] = kabKotaId;
      }

      final response = await _dioClient.dio.get(
        '${AppConfig.baseUrlMajadigi}/api/public/nomor-darurat',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      if (response.statusCode == 200) {
        return _parseList<EmergencyNumberModel>(
          response.data,
          (item) => EmergencyNumberModel.fromJson(item),
        );
      } else {
        throw ServerException(
          message: 'Gagal mengambil nomor darurat (${response.statusCode})',
        );
      }
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Koneksi gagal');
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<KabKotaModel>> getKabKota() async {
    try {
      final response = await _dioClient.dio.get(
        '${AppConfig.baseUrlMajadigi}/api/public/kab-kota',
      );

      if (response.statusCode == 200) {
        return _parseList<KabKotaModel>(
          response.data,
          (item) => KabKotaModel.fromJson(item),
        );
      } else {
        throw ServerException(
          message: 'Gagal mengambil data kab/kota (${response.statusCode})',
        );
      }
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Koneksi gagal');
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  List<T> _parseList<T>(dynamic data, T Function(Map<String, dynamic>) mapper) {
    if (data is Map<String, dynamic> && data.containsKey('data')) {
      final list = data['data'];
      if (list is List) return list.map((e) => mapper(e)).toList();
    }
    if (data is List) return data.map((e) => mapper(e)).toList();
    throw const ServerException(message: 'Format respons tidak valid');
  }
}
