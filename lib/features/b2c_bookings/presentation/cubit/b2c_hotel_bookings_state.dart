import 'package:equatable/equatable.dart';
import '../../domain/entities/b2c_hotel_booking_entity.dart';

abstract class B2CHotelBookingsState extends Equatable {
  const B2CHotelBookingsState();

  @override
  List<Object?> get props => [];
}

class B2CHotelBookingsInitial extends B2CHotelBookingsState {}

class B2CHotelBookingsLoading extends B2CHotelBookingsState {}

class B2CHotelBookingsLoaded extends B2CHotelBookingsState {
  final List<B2CHotelBookingEntity> bookings;

  const B2CHotelBookingsLoaded(this.bookings);

  @override
  List<Object?> get props => [bookings];
}

class B2CHotelBookingsError extends B2CHotelBookingsState {
  final String message;

  const B2CHotelBookingsError(this.message);

  @override
  List<Object?> get props => [message];
}

class B2CHotelBookingCreated extends B2CHotelBookingsState {
  final B2CHotelBookingEntity booking;

  const B2CHotelBookingCreated(this.booking);

  @override
  List<Object?> get props => [booking];
}
