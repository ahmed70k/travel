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

    // Robust role extraction
    final dynamic roleData = payloadMap['role'] ??
        payloadMap['http://schemas.microsoft.com/ws/2008/06/identity/claims/role'] ??
        'b2c';
    String extractedRole = 'b2c';
    if (roleData is List && roleData.isNotEmpty) {
      extractedRole = roleData.first.toString();
    } else {
      extractedRole = roleData.toString();
    }

    return AuthModel(
      user: UserModel(
        id: (payloadMap['sub'] ??
                payloadMap['id'] ??
                payloadMap[
                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'] ??
                '')
            .toString(),
        email: payloadMap['email'] ??
            payloadMap[
                'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress'] ??
            '',
        name: payloadMap['name'] ??
            payloadMap['fullName'] ??
            payloadMap['unique_name'] ??
            payloadMap[
                'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name'] ??
            'User',
        role: extractedRole,
      ),
      accessToken: token,
      refreshToken: data['refreshToken'] ?? data['refresh_token'] ?? '',
    );
  }
}
