import 'package:equatable/equatable.dart';
import '../../domain/entities/admin_users_entity.dart';

abstract class AdminUsersState extends Equatable {
  const AdminUsersState();

  @override
  List<Object?> get props => [];
}

class AdminUsersInitial extends AdminUsersState {}

class AdminUsersLoading extends AdminUsersState {}

class AdminUsersLoaded extends AdminUsersState {
  final List<UserEntity> users;
  final PaginationEntity pagination;

  const AdminUsersLoaded({
    required this.users,
    required this.pagination,
  });

  @override
  List<Object?> get props => [users, pagination];
}

class AdminUsersError extends AdminUsersState {
  final String message;

  const AdminUsersError(this.message);

  @override
  List<Object?> get props => [message];
}
