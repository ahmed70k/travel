part of 'b2b_car_bookings_cubit.dart';

abstract class B2BCarBookingsState extends Equatable {
  const B2BCarBookingsState();

  @override
  List<Object?> get props => [];
}

class B2BCarBookingsInitial extends B2BCarBookingsState {}

class B2BCarBookingsLoading extends B2BCarBookingsState {}

class B2BCarBookingsLoaded extends B2BCarBookingsState {
  final List<CarBookingEntity> bookings;
  const B2BCarBookingsLoaded(this.bookings);

  @override
  List<Object?> get props => [bookings];
}

class B2BCarBookingsError extends B2BCarBookingsState {
  final String message;
  const B2BCarBookingsError(this.message);

  @override
  List<Object?> get props => [message];
}

class B2BCarBookingCreating extends B2BCarBookingsState {}

class B2BCarBookingCreated extends B2BCarBookingsState {
  final CarBookingEntity booking;
  const B2BCarBookingCreated(this.booking);

  @override
  List<Object?> get props => [booking];
}

class B2BCarBookingCreateError extends B2BCarBookingsState {
  final String message;
  const B2BCarBookingCreateError(this.message);

  @override
  List<Object?> get props => [message];
}
