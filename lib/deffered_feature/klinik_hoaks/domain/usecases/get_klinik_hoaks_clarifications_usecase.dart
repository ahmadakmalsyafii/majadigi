import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/deffered_feature/klinik_hoaks/domain/entity/klinik_hoaks_clarification_entity.dart';
import 'package:majadigi/deffered_feature/klinik_hoaks/domain/repositories/klinik_hoaks_repository.dart';

class GetKlinikHoaksClarificationsUseCase {
  final KlinikHoaksRepository repository;

  GetKlinikHoaksClarificationsUseCase({required this.repository});

  Future<Either<Failure, List<KlinikHoaksClarificationEntity>>> call() async {
    return await repository.getClarifications();
  }
}
