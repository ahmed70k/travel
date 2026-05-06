import 'package:equatable/equatable.dart';
import '../../domain/entities/b2c_overview_entity.dart';

abstract class B2COverviewState extends Equatable {
  const B2COverviewState();

  @override
  List<Object> get props => [];
}

class B2COverviewInitial extends B2COverviewState {}

class B2COverviewLoading extends B2COverviewState {}

class B2COverviewLoaded extends B2COverviewState {
  final B2COverviewEntity overview;

  const B2COverviewLoaded(this.overview);

  @override
  List<Object> get props => [overview];
}

class B2COverviewError extends B2COverviewState {
  final String message;

  const B2COverviewError(this.message);

  @override
  List<Object> get props => [message];
}
