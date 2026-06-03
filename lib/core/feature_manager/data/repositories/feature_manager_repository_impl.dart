import '../../domain/repositories/feature_manager_repository.dart';
import '../datasources/feature_manager_local_datasource.dart';

class FeatureManagerRepositoryImpl implements FeatureManagerRepository {
  final FeatureManagerLocalDataSource localDataSource;

  FeatureManagerRepositoryImpl({required this.localDataSource});

  @override
  Future<bool> checkIsInstalled(String featureName) {
    return localDataSource.checkIsInstalled(featureName);
  }

  @override
  Future<void> markAsInstalled(String featureName) {
    return localDataSource.markAsInstalled(featureName);
  }

  @override
  Future<void> removeInstalledStatus(String featureName) {
    return localDataSource.removeInstalledStatus(featureName);
  }
}
