import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/b2c_flight_booking_entity.dart';
import '../../domain/usecases/create_b2c_flight_booking_usecase.dart';
import '../../domain/usecases/get_b2c_flight_bookings_usecase.dart';
import 'b2c_flight_bookings_state.dart';

class B2CFlightBookingsCubit extends Cubit<B2CFlightBookingsState> {
  final GetB2CFlightBookingsUseCase getFlightsUseCase;
  final CreateB2CFlightBookingUseCase createFlightUseCase;

  B2CFlightBookingsCubit({
    required this.getFlightsUseCase,
    required this.createFlightUseCase,
  }) : super(B2CFlightBookingsInitial());

  Future<void> getFlightBookings() async {
    emit(B2CFlightBookingsLoading());
    final result = await getFlightsUseCase();
    result.fold(
      (failure) => emit(B2CFlightBookingsError(failure.message)),
      (bookings) => emit(B2CFlightBookingsLoaded(bookings)),
    );
  }

  Future<void> createFlightBooking(B2CFlightBookingEntity booking) async {
    emit(B2CFlightBookingsLoading());
    final result = await createFlightUseCase(booking);
    result.fold(
      (failure) => emit(B2CFlightBookingsError(failure.message)),
      (newBooking) {
        emit(B2CFlightBookingCreated(newBooking));
        getFlightBookings(); // Refresh the list
      },
    );
  }
}
