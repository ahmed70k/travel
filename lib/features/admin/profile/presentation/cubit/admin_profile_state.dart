import 'package:equatable/equatable.dart';
import '../../../../auth/domain/entities/user_entity.dart';

abstract class AdminProfileState extends Equatable {
  const AdminProfileState();

  @override
  List<Object?> get props => [];
}

class AdminProfileInitial extends AdminProfileState {}

class AdminProfileLoading extends AdminProfileState {}

class AdminProfileLoaded extends AdminProfileState {
  final UserEntity user;
  const AdminProfileLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class AdminProfileError extends AdminProfileState {
  final String message;
  const AdminProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
