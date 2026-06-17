import '../entities/ticket_detail_entity.dart';

abstract class TicketViewerRepository {
  Future<TicketDetailEntity> getTicketDetail(String ticketId, String type);
}
