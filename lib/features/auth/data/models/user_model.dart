import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return UserModel(
      id: (data['id'] ?? data['userId'] ?? '').toString(),
      email: data['email'] ?? data['userName'] ?? '',
      name: data['name'] ?? data['fullName'] ?? data['displayName'] ?? data['email'] ?? 'User',
      role: data['role'] ?? 'b2c', // fallback
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'name': name, 'role': role};
  }
}
