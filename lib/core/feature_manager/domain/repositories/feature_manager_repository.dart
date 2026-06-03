abstract class FeatureManagerRepository {
  Future<bool> checkIsInstalled(String featureName);
  Future<void> markAsInstalled(String featureName);
  Future<void> removeInstalledStatus(String featureName);
}
