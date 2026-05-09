import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String role;
  final String status;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, email, role, status, createdAt];
}

class PaginationEntity extends Equatable {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  const PaginationEntity({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [page, limit, total, totalPages];
}

class UsersResponseDataEntity extends Equatable {
  final List<UserEntity> users;
  final PaginationEntity pagination;

  const UsersResponseDataEntity({
    required this.users,
    required this.pagination,
  });

  @override
  List<Object?> get props => [users, pagination];
}
