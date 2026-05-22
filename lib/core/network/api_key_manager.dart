import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:majadigi/core/config/app_config.dart';

class ApiKeyManager {
  final FirebaseRemoteConfig _remoteConfig;
  bool _initialized = false;

  ApiKeyManager(this._remoteConfig);

  Future<void> init() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );

    await _remoteConfig.fetchAndActivate();
    _initialized = true;
  }

  String getKey(ApiEndpoint endpoint) {
    return switch (endpoint) {
      ApiEndpoint.hargaBahanPokok => AppConfig.apiKeyHargaBahanPokok,
      ApiEndpoint.saifulAnwar => AppConfig.apiKeySaifulAnwar,
      ApiEndpoint.dahaHusada => AppConfig.apiKeyDahaHusada,
      ApiEndpoint.karsaHusada => AppConfig.apiKeyKarsaHusada,
      ApiEndpoint.haji => AppConfig.apiKeyHaji,
      ApiEndpoint.nomorDarurat => '',
    };
  }
}

enum ApiEndpoint {
  hargaBahanPokok,
  saifulAnwar,
  dahaHusada,
  karsaHusada,
  haji,
  nomorDarurat,
}
