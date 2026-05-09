part of 'b2b_flight_bookings_cubit.dart';

abstract class B2BFlightBookingsState extends Equatable {
  const B2BFlightBookingsState();

  @override
  List<Object?> get props => [];
}

class B2BFlightBookingsInitial extends B2BFlightBookingsState {}

class B2BFlightBookingsLoading extends B2BFlightBookingsState {}

class B2BFlightBookingsLoaded extends B2BFlightBookingsState {
  final List<FlightBookingEntity> bookings;
  const B2BFlightBookingsLoaded(this.bookings);

  @override
  List<Object?> get props => [bookings];
}

class B2BFlightBookingsError extends B2BFlightBookingsState {
  final String message;
  const B2BFlightBookingsError(this.message);

  @override
  List<Object?> get props => [message];
}

class B2BFlightBookingCreating extends B2BFlightBookingsState {}

class B2BFlightBookingCreated extends B2BFlightBookingsState {
  final FlightBookingEntity booking;
  const B2BFlightBookingCreated(this.booking);

  @override
  List<Object?> get props => [booking];
}

class B2BFlightBookingCreateError extends B2BFlightBookingsState {
  final String message;
  const B2BFlightBookingCreateError(this.message);

  @override
  List<Object?> get props => [message];
}
