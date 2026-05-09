import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/b2c_car_booking_entity.dart';
import '../../domain/usecases/create_b2c_car_booking_usecase.dart';
import '../../domain/usecases/get_b2c_car_bookings_usecase.dart';
import 'b2c_car_bookings_state.dart';

class B2CCarBookingsCubit extends Cubit<B2CCarBookingsState> {
  final GetB2CCarBookingsUseCase getCarsUseCase;
  final CreateB2CCarBookingUseCase createCarUseCase;

  B2CCarBookingsCubit({
    required this.getCarsUseCase,
    required this.createCarUseCase,
  }) : super(B2CCarBookingsInitial());

  Future<void> getCarBookings() async {
    emit(B2CCarBookingsLoading());
    final result = await getCarsUseCase();
    result.fold(
      (failure) => emit(B2CCarBookingsError(failure.message)),
      (bookings) => emit(B2CCarBookingsLoaded(bookings)),
    );
  }

  Future<void> createCarBooking(B2CCarBookingEntity booking) async {
    emit(B2CCarBookingsLoading());
    final result = await createCarUseCase(booking);
    result.fold(
      (failure) => emit(B2CCarBookingsError(failure.message)),
      (newBooking) {
        emit(B2CCarBookingCreated(newBooking));
        getCarBookings(); // Refresh the list
      },
    );
  }
}
