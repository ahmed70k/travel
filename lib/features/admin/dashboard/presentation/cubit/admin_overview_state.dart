import 'package:equatable/equatable.dart';
import '../../domain/entities/admin_overview_entity.dart';

abstract class AdminOverviewState extends Equatable {
  const AdminOverviewState();

  @override
  List<Object?> get props => [];
}

class AdminOverviewInitial extends AdminOverviewState {}

class AdminOverviewLoading extends AdminOverviewState {}

class AdminOverviewLoaded extends AdminOverviewState {
  final AdminOverviewEntity overview;

  const AdminOverviewLoaded(this.overview);

  @override
  List<Object?> get props => [overview];
}

class AdminOverviewError extends AdminOverviewState {
  final String message;

  const AdminOverviewError(this.message);

  @override
  List<Object?> get props => [message];
}
