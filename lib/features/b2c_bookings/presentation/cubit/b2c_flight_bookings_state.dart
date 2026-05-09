import 'package:equatable/equatable.dart';
import '../../domain/entities/b2c_flight_booking_entity.dart';

abstract class B2CFlightBookingsState extends Equatable {
  const B2CFlightBookingsState();

  @override
  List<Object?> get props => [];
}

class B2CFlightBookingsInitial extends B2CFlightBookingsState {}

class B2CFlightBookingsLoading extends B2CFlightBookingsState {}

class B2CFlightBookingsLoaded extends B2CFlightBookingsState {
  final List<B2CFlightBookingEntity> bookings;

  const B2CFlightBookingsLoaded(this.bookings);

  @override
  List<Object?> get props => [bookings];
}

class B2CFlightBookingsError extends B2CFlightBookingsState {
  final String message;

  const B2CFlightBookingsError(this.message);

  @override
  List<Object?> get props => [message];
}

class B2CFlightBookingCreated extends B2CFlightBookingsState {
  final B2CFlightBookingEntity booking;

  const B2CFlightBookingCreated(this.booking);

  @override
  List<Object?> get props => [booking];
}
