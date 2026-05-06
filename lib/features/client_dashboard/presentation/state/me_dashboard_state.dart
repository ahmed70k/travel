import 'package:equatable/equatable.dart';
import '../../domain/entities/me_dashboard_entity.dart';

abstract class MeDashboardState extends Equatable {
  const MeDashboardState();
  @override
  List<Object> get props => [];
}

class MeDashboardInitial extends MeDashboardState {}

class MeDashboardLoading extends MeDashboardState {}

class MeDashboardLoaded extends MeDashboardState {
  final MeDashboardEntity data;
  const MeDashboardLoaded(this.data);
  @override
  List<Object> get props => [data];
}

class MeDashboardError extends MeDashboardState {
  final String message;
  const MeDashboardError(this.message);
  @override
  List<Object> get props => [message];
}
