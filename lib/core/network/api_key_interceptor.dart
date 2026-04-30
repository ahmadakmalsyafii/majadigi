import 'package:dio/dio.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/core/network/api_key_manager.dart';
import 'package:majadigi/features/auth/presentation/bloc/auth_state.dart';

class ApiKeyInterceptor extends Interceptor {
  final ApiKeyManager _keyManager;
  ApiKeyInterceptor(this._keyManager);

  static final _endpointMap = <RegExp, ApiEndpoint>{
    RegExp(r'/disperindag/commodity'): ApiEndpoint.hargaBahanPokok,
    RegExp(r'/rssa/rooms'): ApiEndpoint.saifulAnwar,
    RegExp(r'/rsud-daha-husada'): ApiEndpoint.dahaHusada,
    RegExp(r'/rsukarsahusadabatu'): ApiEndpoint.karsaHusada,
    RegExp(r'/rshaji'): ApiEndpoint.haji,
  };

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final path = options.path;
    for (final entry in _endpointMap.entries) {
      if (entry.key.hasMatch(path)) {
        final key = _keyManager.getKey(entry.value);
        if (key.isNotEmpty) {
          options.headers['ApiKey'] = key;
        }
        break;
      }
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final failure = switch (err.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout =>
        const NetworkFailure(),
      DioExceptionType.badResponse when
        (err.response?.statusCode ?? 0) == 401 =>
      const UnauthorizedFailure(),
      _ => ServerFailure(),
    };
    handler.reject(DioException(
      requestOptions: err.requestOptions,
      error: failure,
    ));
  }
}