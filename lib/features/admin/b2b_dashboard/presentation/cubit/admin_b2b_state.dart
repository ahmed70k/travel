import 'package:equatable/equatable.dart';
import 'package:travle/features/admin/b2b_dashboard/domain/entities/admin_b2b_entity.dart';

abstract class AdminB2BState extends Equatable {
  const AdminB2BState();

  @override
  List<Object?> get props => [];
}

class AdminB2BInitial extends AdminB2BState {}

class AdminB2BLoading extends AdminB2BState {}

class AdminB2BLoaded extends AdminB2BState {
  final AdminB2BEntity dashboardData;

  const AdminB2BLoaded({required this.dashboardData});

  @override
  List<Object?> get props => [dashboardData];
}

class AdminB2BError extends AdminB2BState {
  final String message;

  const AdminB2BError({required this.message});

  @override
  List<Object?> get props => [message];
}
