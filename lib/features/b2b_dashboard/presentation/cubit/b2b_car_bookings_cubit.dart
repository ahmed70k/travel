import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/booking_entities.dart';
import '../../domain/usecases/get_cars_bookings_usecase.dart';
import '../../domain/usecases/create_car_booking_usecase.dart';

part 'b2b_car_bookings_state.dart';

class B2BCarBookingsCubit extends Cubit<B2BCarBookingsState> {
  final GetB2BCarsBookingsUseCase getCarsUseCase;
  final CreateB2BCarBookingUseCase createCarUseCase;

  B2BCarBookingsCubit({
    required this.getCarsUseCase,
    required this.createCarUseCase,
  }) : super(B2BCarBookingsInitial());

  Future<void> getCarsBookings() async {
    emit(B2BCarBookingsLoading());
    final result = await getCarsUseCase();
    result.fold(
      (failure) => emit(B2BCarBookingsError(failure.message)),
      (bookings) => emit(B2BCarBookingsLoaded(bookings)),
    );
  }

  Future<void> createCarBooking(CarBookingEntity booking) async {
    emit(B2BCarBookingCreating());
    final result = await createCarUseCase(booking);
    result.fold(
      (failure) => emit(B2BCarBookingCreateError(failure.message)),
      (createdBooking) {
        emit(B2BCarBookingCreated(createdBooking));
        getCarsBookings();
      },
    );
  }
}
