import 'package:equatable/equatable.dart';
import '../../domain/entities/booking_entities.dart';

abstract class B2BMyBookingsState extends Equatable {
  const B2BMyBookingsState();

  @override
  List<Object?> get props => [];
}

class B2BMyBookingsInitial extends B2BMyBookingsState {}

class B2BMyBookingsLoading extends B2BMyBookingsState {}

class B2BMyBookingsLoaded extends B2BMyBookingsState {
  final MyBookingsEntity bookings;

  const B2BMyBookingsLoaded(this.bookings);

  @override
  List<Object?> get props => [bookings];
}

class B2BMyBookingsError extends B2BMyBookingsState {
  final String message;

  const B2BMyBookingsError(this.message);

  @override
  List<Object?> get props => [message];
}
