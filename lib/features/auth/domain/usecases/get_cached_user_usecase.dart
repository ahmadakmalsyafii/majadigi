
import 'package:majadigi/features/auth/domain/repositories/auth_repository.dart';

class GetCachedUserUsecase {
  final AuthRepository repository;

  GetCachedUserUsecase(this.repository);

  Future call() async {
    return await repository.getCachedUser();
  }
}