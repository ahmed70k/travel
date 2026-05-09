import 'package:equatable/equatable.dart';
import '../../domain/entities/current_dashboard_entity.dart';

abstract class B2cOverviewState extends Equatable {
  const B2cOverviewState();

  @override
  List<Object?> get props => [];
}

class B2cOverviewInitial extends B2cOverviewState {}

class B2cOverviewLoading extends B2cOverviewState {}

class B2cOverviewLoaded extends B2cOverviewState {
  final B2cDashboardDataEntity overview;

  const B2cOverviewLoaded(this.overview);

  @override
  List<Object?> get props => [overview];
}

class B2cOverviewError extends B2cOverviewState {
  final String message;

  const B2cOverviewError(this.message);

  @override
  List<Object?> get props => [message];
}
