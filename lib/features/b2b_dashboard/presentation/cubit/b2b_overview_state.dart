import 'package:equatable/equatable.dart';
import '../../domain/entities/b2b_overview_entity.dart';

abstract class B2BOverviewState extends Equatable {
  const B2BOverviewState();

  @override
  List<Object?> get props => [];
}

class B2BOverviewInitial extends B2BOverviewState {}

class B2BOverviewLoading extends B2BOverviewState {}

class B2BOverviewLoaded extends B2BOverviewState {
  final B2BOverviewEntity overview;

  const B2BOverviewLoaded(this.overview);

  @override
  List<Object?> get props => [overview];
}

class B2BOverviewError extends B2BOverviewState {
  final String message;

  const B2BOverviewError(this.message);

  @override
  List<Object?> get props => [message];
}
