import 'package:dio/dio.dart';
import 'package:majadigi/core/error/exceptions.dart';
import 'package:majadigi/core/network/dio_client.dart';
import 'package:majadigi/deffered_feature/ketersediaan_kamar/data/model/room_availability_model.dart';

abstract class KetersediaanKamarRemoteDataSource {
  Future<RoomAvailabilityModel> getRoomAvailability(String hospitalName);
}

class KetersediaanKamarRemoteDataSourceImpl implements KetersediaanKamarRemoteDataSource {
  final DioClient dioClient;

  KetersediaanKamarRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<RoomAvailabilityModel> getRoomAvailability(String hospitalName) async {
    final lower = hospitalName.toLowerCase();
    String path = '';

    if (lower.contains('saiful anwar') || lower.contains('rssa')) {
      path = '/t/jatimprov.go.id/rssa/rooms/v1/';
    } else if (lower.contains('daha husada')) {
      path = '/t/jatimprov.go.id/kominfo/transformer/v1/rsud-daha-husada/rooms';
    } else if (lower.contains('karsa husada')) {
      path = '/t/jatimprov.go.id/rsukarsahusadabatu/simrs/v1/rooms';
    } else if (lower.contains('haji')) {
      path = '/t/jatimprov.go.id/kominfo/transformer/v1/rshaji/room-occupancy';
    } else {
      throw ServerException(message: 'Rumah sakit tidak didukung untuk layanan ini.');
    }

    try {
      final response = await dioClient.dio.get(
        'https://api-splp.layanan.go.id$path',
      );
      
      if (response.data != null && response.statusCode == 200) {
        return RoomAvailabilityModel.fromJson(response.data);
      } else {
        throw ServerException(message: 'Gagal mengambil data ketersediaan kamar');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Gagal menghubungi server');
    } catch (e) {
      throw ServerException(message: 'Terjadi kesalahan sistem.');
    }
  }
}
