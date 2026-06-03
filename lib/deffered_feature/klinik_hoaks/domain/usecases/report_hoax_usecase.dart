import 'package:dartz/dartz.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/deffered_feature/klinik_hoaks/domain/repositories/klinik_hoaks_repository.dart';

class ReportHoaxUseCase {
  final KlinikHoaksRepository repository;

  ReportHoaxUseCase({required this.repository});

  Future<Either<Failure, bool>> call({
    required String info,
    required String source,
    String? filePath,
  }) async {
    return await repository.reportHoax(
      info: info,
      source: source,
      filePath: filePath,
    );
  }
}
