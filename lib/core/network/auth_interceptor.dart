import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../di/dependency_injection.dart'; // To access globalNavigatorKey
import 'dio_client.dart';
import 'api_constants.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage secureStorage;
  final AuthRepository Function()
  authRepo; // Lazy loading to avoid circular dep
  final DioClient Function() dioClient; // Lazy loading

  bool _isRefreshing = false;
  final List<Map<String, dynamic>> _failedRequestsQueue = [];

  AuthInterceptor({
    required this.secureStorage,
    required this.authRepo,
    required this.dioClient,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!options.path.contains(ApiConstants.login) &&
        !options.path.contains(ApiConstants.refresh)) {
      final accessToken = await secureStorage.read(key: 'access_token');
      if (accessToken != null) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 &&
        !err.requestOptions.path.contains(ApiConstants.login) &&
        !err.requestOptions.path.contains(ApiConstants.refresh)) {
      if (_isRefreshing) {
        // If already refreshing, add to queue
        final completer = Completer<Response>();
        _failedRequestsQueue.add({
          'options': err.requestOptions,
          'completer': completer,
        });

        try {
          final response = await completer.future;
          return handler.resolve(response);
        } catch (e) {
          return handler.next(err);
        }
      }

      _isRefreshing = true;

      try {
        // Attempt to refresh token
        final repository = authRepo();
        final newAuth = await repository.refreshToken();

        // Update headers of original request
        err.requestOptions.headers['Authorization'] =
            'Bearer ${newAuth.accessToken}';

        // Retry the original request
        final dio = dioClient().dio;
        final response = await dio.fetch(err.requestOptions);

        // Resolve queue
        for (var request in _failedRequestsQueue) {
          final options = request['options'] as RequestOptions;
          final completer = request['completer'] as Completer<Response>;
          options.headers['Authorization'] = 'Bearer ${newAuth.accessToken}';
          dio
              .fetch(options)
              .then((res) => completer.complete(res))
              .catchError((e) => completer.completeError(e));
        }
        _failedRequestsQueue.clear();
        _isRefreshing = false;

        return handler.resolve(response);
      } catch (refreshError) {
        // Refresh failed, log out
        _isRefreshing = false;
        _failedRequestsQueue.clear();
        await authRepo().logout();

        // Navigate to Login Page
        if (globalNavigatorKey.currentContext != null) {
          Navigator.of(globalNavigatorKey.currentContext!).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        }

        return handler.next(err);
      }
    }

    super.onError(err, handler);
  }
}
