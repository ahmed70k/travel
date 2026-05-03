import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  });
  Future<void> saveRole(String role);
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<String?> getRole();
  Future<void> clearAll();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({
    required this.secureStorage,
    required this.sharedPreferences,
  });

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await secureStorage.write(key: 'access_token', value: accessToken);
    await secureStorage.write(key: 'refresh_token', value: refreshToken);
  }

  @override
  Future<void> saveRole(String role) async {
    await sharedPreferences.setString('user_role', role);
  }

  @override
  Future<String?> getAccessToken() async {
    return await secureStorage.read(key: 'access_token');
  }

  @override
  Future<String?> getRefreshToken() async {
    return await secureStorage.read(key: 'refresh_token');
  }

  @override
  Future<String?> getRole() async {
    return sharedPreferences.getString('user_role');
  }

  @override
  Future<void> clearAll() async {
    await secureStorage.deleteAll();
    await sharedPreferences.remove('user_role');
  }
}
