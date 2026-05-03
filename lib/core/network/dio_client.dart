import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'api_constants.dart';

class DioClient {
  late final Dio _dio;

  DioClient({Interceptor? authInterceptor}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    if (authInterceptor != null) {
      _dio.interceptors.add(authInterceptor);
    }

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
        ),
      );
    }
  }

  Dio get dio => _dio;
}
