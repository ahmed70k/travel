import 'dart:convert';
import '../../domain/entities/auth_entity.dart';
import 'user_model.dart';

class AuthModel extends AuthEntity {
  const AuthModel({
    required super.user,
    required super.accessToken,
    required super.refreshToken,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    // Handle nested 'data' object if present
    final data = json['data'] ?? json;
    final token =
        data['accessToken'] ?? data['token'] ?? data['access_token'] ?? '';

    if (token.isEmpty) {
      throw Exception("Token not found in response");
    }

    // Decode token
    final parts = token.split('.');
    if (parts.length != 3) throw Exception('Invalid JWT token');

    final payload = base64Url.normalize(parts[1]);
    final String decoded = utf8.decode(base64Url.decode(payload));
    final Map<String, dynamic> payloadMap = jsonDecode(decoded);

    return AuthModel(
      user: UserModel(
        id: payloadMap['sub']?.toString() ?? '',
        email: payloadMap['email'] ?? '',
        name: payloadMap['name'] ?? 'User',
        role: payloadMap['role'] ?? 'b2c',
      ),
      accessToken: token,
      refreshToken: data['refreshToken'] ?? data['refresh_token'] ?? '',
    );
  }
}
