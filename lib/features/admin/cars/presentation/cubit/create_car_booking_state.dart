import 'package:equatable/equatable.dart';
import '../../domain/entities/car_booking_entity.dart';

abstract class CreateCarBookingState extends Equatable {
  const CreateCarBookingState();

  @override
  List<Object?> get props => [];
}

class CreateCarBookingInitial extends CreateCarBookingState {}

class CreateCarBookingLoading extends CreateCarBookingState {}

class CreateCarBookingSuccess extends CreateCarBookingState {
  final CarBookingEntity booking;

  const CreateCarBookingSuccess(this.booking);

  @override
  List<Object?> get props => [booking];
}

class CreateCarBookingError extends CreateCarBookingState {
  final String message;

  const CreateCarBookingError(this.message);

  @override
  List<Object?> get props => [message];
}
