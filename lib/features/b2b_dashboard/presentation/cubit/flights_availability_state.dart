import 'package:equatable/equatable.dart';
import '../../domain/entities/availability_entity.dart';

abstract class FlightsAvailabilityState extends Equatable {
  const FlightsAvailabilityState();

  @override
  List<Object?> get props => [];
}

class FlightsAvailabilityInitial extends FlightsAvailabilityState {}

class FlightsAvailabilityLoading extends FlightsAvailabilityState {}

class FlightsAvailabilityLoaded extends FlightsAvailabilityState {
  final AvailabilityEntity availability;
  const FlightsAvailabilityLoaded(this.availability);

  @override
  List<Object?> get props => [availability];
}

class FlightsAvailabilityError extends FlightsAvailabilityState {
  final String message;
  const FlightsAvailabilityError(this.message);

  @override
  List<Object?> get props => [message];
}
