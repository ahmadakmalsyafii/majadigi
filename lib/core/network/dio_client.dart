import 'package:dio/dio.dart';
import 'package:majadigi/core/config/app_config.dart';
import 'package:majadigi/core/network/api_key_interceptor.dart';
import 'package:majadigi/core/network/api_key_manager.dart';

class DioClient {
  late final Dio _dio;

  DioClient(ApiKeyManager keyManager) {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrlLayanan,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
      ),
    );

    _dio.interceptors.addAll([
      ApiKeyInterceptor(keyManager),
      LogInterceptor(requestBody: false, responseBody: false, error: true),
    ]);
  }

  Dio get dio => _dio;
}
