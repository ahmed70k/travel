import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/booking_entities.dart';
import '../../domain/usecases/get_flights_bookings_usecase.dart';
import '../../domain/usecases/create_flight_booking_usecase.dart';

part 'b2b_flight_bookings_state.dart';

class B2BFlightBookingsCubit extends Cubit<B2BFlightBookingsState> {
  final GetB2BFlightsBookingsUseCase getFlightsUseCase;
  final CreateB2BFlightBookingUseCase createFlightUseCase;

  B2BFlightBookingsCubit({
    required this.getFlightsUseCase,
    required this.createFlightUseCase,
  }) : super(B2BFlightBookingsInitial());

  Future<void> getFlightsBookings() async {
    emit(B2BFlightBookingsLoading());
    final result = await getFlightsUseCase();
    result.fold(
      (failure) => emit(B2BFlightBookingsError(failure.message)),
      (bookings) => emit(B2BFlightBookingsLoaded(bookings)),
    );
  }

  Future<void> createFlightBooking(FlightBookingEntity booking) async {
    emit(B2BFlightBookingCreating());
    final result = await createFlightUseCase(booking);
    result.fold(
      (failure) => emit(B2BFlightBookingCreateError(failure.message)),
      (createdBooking) {
        emit(B2BFlightBookingCreated(createdBooking));
        getFlightsBookings(); // Auto refresh list
      },
    );
  }
}
