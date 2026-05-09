part of 'create_flight_booking_cubit.dart';

abstract class CreateFlightBookingState extends Equatable {
  const CreateFlightBookingState();

  @override
  List<Object?> get props => [];
}

class CreateFlightBookingInitial extends CreateFlightBookingState {}

class CreateFlightBookingLoading extends CreateFlightBookingState {}

class CreateFlightBookingSuccess extends CreateFlightBookingState {
  final FlightBookingEntity booking;

  const CreateFlightBookingSuccess(this.booking);

  @override
  List<Object?> get props => [booking];
}

class CreateFlightBookingError extends CreateFlightBookingState {
  final String message;

  const CreateFlightBookingError(this.message);

  @override
  List<Object?> get props => [message];
}
