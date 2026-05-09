import '../../domain/entities/admin_users_entity.dart';

class UsersResponseModel extends UsersResponseDataEntity {
  const UsersResponseModel({
    required super.users,
    required super.pagination,
  });

  factory UsersResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return UsersResponseModel(
      users: (data['data'] as List)
          .map((user) => UserModel.fromJson(user))
          .toList(),
      pagination: PaginationModel.fromJson(data['pagination']),
    );
  }
}

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    required super.status,
    required super.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
    );
  }
}

class PaginationModel extends PaginationEntity {
  const PaginationModel({
    required super.page,
    required super.limit,
    required super.total,
    required super.totalPages,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 1,
    );
  }
}
