import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:majadigi/core/config/app_config.dart';

class ApiKeyManager {
  final FirebaseRemoteConfig _remoteConfig;
  bool _initialized = false;

  ApiKeyManager(this._remoteConfig);

  Future<void> init() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(hours: 1),
    ));

    await _remoteConfig.fetchAndActivate();
    _initialized = true;
  }

  String getKey(ApiEndpoint endpoint) {
    if (!_initialized) throw StateError('ApiKeyManager not initialized');
    return switch (endpoint) {
      ApiEndpoint.hargaBahanPokok => _remoteConfig.getString('api_key_harga_bahan_pokok'),
      ApiEndpoint.saifulAnwar      => _remoteConfig.getString('api_key_saiful_anwar'),
      ApiEndpoint.dahaHusada      => _remoteConfig.getString('api_key_daha_husada'),
      ApiEndpoint.karsaHusada     => _remoteConfig.getString('api_key_karsa_husada'),
      ApiEndpoint.haji      => _remoteConfig.getString('api_key_haji'),
      ApiEndpoint.nomorDarurat => '',
    };
  }
}

enum ApiEndpoint { hargaBahanPokok, saifulAnwar, dahaHusada, karsaHusada, haji, nomorDarurat }
