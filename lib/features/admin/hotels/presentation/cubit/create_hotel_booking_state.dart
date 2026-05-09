import 'package:equatable/equatable.dart';

abstract class CreateHotelBookingState extends Equatable {
  const CreateHotelBookingState();

  @override
  List<Object?> get props => [];
}

class CreateHotelBookingInitial extends CreateHotelBookingState {
  const CreateHotelBookingInitial();
}

class CreateHotelBookingLoading extends CreateHotelBookingState {
  const CreateHotelBookingLoading();
}

class CreateHotelBookingSuccess extends CreateHotelBookingState {
  final Map<String, dynamic> booking;
  const CreateHotelBookingSuccess(this.booking);

  @override
  List<Object?> get props => [booking];
}

class CreateHotelBookingError extends CreateHotelBookingState {
  final String message;
  const CreateHotelBookingError(this.message);

  @override
  List<Object?> get props => [message];
}
