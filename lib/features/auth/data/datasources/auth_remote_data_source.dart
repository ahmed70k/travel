import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/error_handler.dart';
import '../models/auth_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthModel> login(String email, String password);
  Future<AuthModel> refreshToken(String refreshToken);
  Future<UserModel> getCurrentUser();
  Future<void> logout(String refreshToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<AuthModel> login(String email, String password) async {
    try {
      final response = await dio.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );

      return AuthModel.fromJson(response.data);
    } catch (e) {
      throw Exception(ErrorHandler.handle(e));
    }
  }

  @override
  Future<AuthModel> refreshToken(String refreshToken) async {
    try {
      // Using a clean Dio instance to avoid interceptor loop
      final refreshDio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      final response = await refreshDio.post(
        ApiConstants.refresh,
        data: {'refreshToken': refreshToken},
      );

      return AuthModel.fromJson(response.data);
    } catch (e) {
      throw Exception("فشل تجديد الجلسة: \${ErrorHandler.handle(e)}");
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await dio.get(ApiConstants.me); // uses interceptor
      return UserModel.fromJson(response.data);
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 404) {
        throw Exception("USER_NOT_FOUND");
      }
      throw Exception(ErrorHandler.handle(e));
    }
  }

  @override
  Future<void> logout(String refreshToken) async {
    try {
      await dio.post(ApiConstants.logout, data: {'refreshToken': refreshToken});
    } catch (e) {
      // We don't throw here to allow local logout to continue
      print("Remote logout failed: $e");
    }
  }
}
