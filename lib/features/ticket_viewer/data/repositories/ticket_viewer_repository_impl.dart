import 'package:injectable/injectable.dart';
import '../../domain/entities/ticket_detail_entity.dart';
import '../../domain/repositories/ticket_viewer_repository.dart';
import '../datasources/ticket_viewer_remote_datasource.dart';

@LazySingleton(as: TicketViewerRepository)
class TicketViewerRepositoryImpl implements TicketViewerRepository {
  final TicketViewerRemoteDataSource remoteDataSource;

  TicketViewerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<TicketDetailEntity> getTicketDetail(
    String ticketId,
    String type,
  ) async {
    try {
      final rawData = await remoteDataSource.getTicketData(ticketId, type);

      final specificDetails = <String, dynamic>{};

      if (type == 'islamic_center') {
        specificDetails['Fasilitas'] = rawData['roomName'] ?? '-';
        specificDetails['Tanggal Reservasi'] = rawData['reserv_date'] ?? '-';
        specificDetails['Waktu'] = rawData['reserv_time'] ?? '-';
      } else if (type == 'destinasi_wisata') {
        specificDetails['Destinasi'] = rawData['destinationName'] ?? '-';
        specificDetails['Tanggal'] = rawData['date'] ?? '-';
        specificDetails['Jumlah Tiket'] =
            rawData['total_ticket']?.toString() ?? '-';
        specificDetails['NIK'] = rawData['nik'] ?? '-';
      }

      return TicketDetailEntity(
        id: rawData['id'] ?? '',
        orderNumber: rawData['order_number']?.toString() ?? '-',
        name: rawData['name'] ?? '-',
        status: rawData['status'] ?? '-',
        paymentMethod: rawData['payment_method'] ?? '-',
        ticketType: type,
        specificDetails: specificDetails,
      );
    } catch (e) {
      throw Exception('Failed to get ticket detail: ${e.toString()}');
    }
  }
}
