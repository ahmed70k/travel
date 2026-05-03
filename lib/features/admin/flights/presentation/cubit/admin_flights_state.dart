import 'package:equatable/equatable.dart';
import '../../domain/entities/admin_flights_entity.dart';

abstract class AdminFlightsState extends Equatable {
  const AdminFlightsState();

  @override
  List<Object?> get props => [];
}

class AdminFlightsInitial extends AdminFlightsState {}

class AdminFlightsLoading extends AdminFlightsState {}

class AdminFlightsLoaded extends AdminFlightsState {
  final AdminFlightsEntity data;

  const AdminFlightsLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class AdminFlightsError extends AdminFlightsState {
  final String message;

  const AdminFlightsError(this.message);

  @override
  List<Object?> get props => [message];
}
