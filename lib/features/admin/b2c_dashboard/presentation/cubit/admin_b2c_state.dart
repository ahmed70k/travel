import 'package:equatable/equatable.dart';
import 'package:travle/features/admin/b2c_dashboard/domain/entities/admin_b2c_entity.dart';

abstract class AdminB2CState extends Equatable {
  const AdminB2CState();

  @override
  List<Object> get props => [];
}

class AdminB2CInitial extends AdminB2CState {}

class AdminB2CLoading extends AdminB2CState {}

class AdminB2CLoaded extends AdminB2CState {
  final AdminB2CEntity dashboardData;

  const AdminB2CLoaded(this.dashboardData);

  @override
  List<Object> get props => [dashboardData];
}

class AdminB2CError extends AdminB2CState {
  final String message;

  const AdminB2CError(this.message);

  @override
  List<Object> get props => [message];
}
