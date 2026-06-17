import 'package:injectable/injectable.dart';
import '../entities/ticket_detail_entity.dart';
import '../repositories/ticket_viewer_repository.dart';

@lazySingleton
class GetTicketDetailUsecase {
  final TicketViewerRepository repository;

  GetTicketDetailUsecase(this.repository);

  Future<TicketDetailEntity> call(String ticketId, String type) async {
    return await repository.getTicketDetail(ticketId, type);
  }
}
