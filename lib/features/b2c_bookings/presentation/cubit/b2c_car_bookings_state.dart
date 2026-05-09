import 'package:equatable/equatable.dart';
import '../../domain/entities/b2c_car_booking_entity.dart';

abstract class B2CCarBookingsState extends Equatable {
  const B2CCarBookingsState();

  @override
  List<Object?> get props => [];
}

class B2CCarBookingsInitial extends B2CCarBookingsState {}

class B2CCarBookingsLoading extends B2CCarBookingsState {}

class B2CCarBookingsLoaded extends B2CCarBookingsState {
  final List<B2CCarBookingEntity> bookings;

  const B2CCarBookingsLoaded(this.bookings);

  @override
  List<Object?> get props => [bookings];
}

class B2CCarBookingsError extends B2CCarBookingsState {
  final String message;

  const B2CCarBookingsError(this.message);

  @override
  List<Object?> get props => [message];
}

class B2CCarBookingCreated extends B2CCarBookingsState {
  final B2CCarBookingEntity booking;

  const B2CCarBookingCreated(this.booking);

  @override
  List<Object?> get props => [booking];
}
