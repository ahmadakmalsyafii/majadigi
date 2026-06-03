import 'package:shared_preferences/shared_preferences.dart';

abstract class FeatureManagerLocalDataSource {
  Future<bool> checkIsInstalled(String featureName);
  Future<void> markAsInstalled(String featureName);
  Future<void> removeInstalledStatus(String featureName);
}

class FeatureManagerLocalDataSourceImpl implements FeatureManagerLocalDataSource {
  final SharedPreferences sharedPreferences;

  FeatureManagerLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<bool> checkIsInstalled(String featureName) async {
    return sharedPreferences.getBool('feature_installed_$featureName') ?? false;
  }

  @override
  Future<void> markAsInstalled(String featureName) async {
    await sharedPreferences.setBool('feature_installed_$featureName', true);
  }

  @override
  Future<void> removeInstalledStatus(String featureName) async {
    await sharedPreferences.remove('feature_installed_$featureName');
  }
}
