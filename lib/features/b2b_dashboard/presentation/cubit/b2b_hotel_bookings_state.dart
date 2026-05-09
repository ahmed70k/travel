part of 'b2b_hotel_bookings_cubit.dart';

abstract class B2BHotelBookingsState extends Equatable {
  const B2BHotelBookingsState();

  @override
  List<Object?> get props => [];
}

class B2BHotelBookingsInitial extends B2BHotelBookingsState {}

class B2BHotelBookingsLoading extends B2BHotelBookingsState {}

class B2BHotelBookingsLoaded extends B2BHotelBookingsState {
  final List<HotelBookingEntity> bookings;
  const B2BHotelBookingsLoaded(this.bookings);

  @override
  List<Object?> get props => [bookings];
}

class B2BHotelBookingsError extends B2BHotelBookingsState {
  final String message;
  const B2BHotelBookingsError(this.message);

  @override
  List<Object?> get props => [message];
}

class B2BHotelBookingCreating extends B2BHotelBookingsState {}

class B2BHotelBookingCreated extends B2BHotelBookingsState {
  final HotelBookingEntity booking;
  const B2BHotelBookingCreated(this.booking);

  @override
  List<Object?> get props => [booking];
}

class B2BHotelBookingCreateError extends B2BHotelBookingsState {
  final String message;
  const B2BHotelBookingCreateError(this.message);

  @override
  List<Object?> get props => [message];
}
