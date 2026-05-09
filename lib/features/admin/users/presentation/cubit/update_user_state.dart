import 'package:equatable/equatable.dart';
import '../../domain/entities/admin_users_entity.dart';

abstract class UpdateUserState extends Equatable {
  const UpdateUserState();

  @override
  List<Object?> get props => [];
}

class UpdateUserInitial extends UpdateUserState {}

class UpdateUserLoading extends UpdateUserState {}

class UpdateUserSuccess extends UpdateUserState {
  final UserEntity user;

  const UpdateUserSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class UpdateUserError extends UpdateUserState {
  final String message;

  const UpdateUserError(this.message);

  @override
  List<Object?> get props => [message];
}
