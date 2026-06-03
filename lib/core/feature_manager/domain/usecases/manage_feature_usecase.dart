import '../repositories/feature_manager_repository.dart';

class ManageFeatureUsecase {
  final FeatureManagerRepository repository;
  ManageFeatureUsecase(this.repository);

  Future<bool> checkIsInstalled(String featureName) {
    return repository.checkIsInstalled(featureName);
  }

  Future<void> markAsInstalled(String featureName) {
    return repository.markAsInstalled(featureName);
  }

  Future<void> removeInstalledStatus(String featureName) {
    return repository.removeInstalledStatus(featureName);
  }
}
