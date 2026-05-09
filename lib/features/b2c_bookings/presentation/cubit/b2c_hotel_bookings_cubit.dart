import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/b2c_hotel_booking_entity.dart';
import '../../domain/usecases/create_b2c_hotel_booking_usecase.dart';
import '../../domain/usecases/get_b2c_hotel_bookings_usecase.dart';
import 'b2c_hotel_bookings_state.dart';

class B2CHotelBookingsCubit extends Cubit<B2CHotelBookingsState> {
  final GetB2CHotelBookingsUseCase getHotelsUseCase;
  final CreateB2CHotelBookingUseCase createHotelUseCase;

  B2CHotelBookingsCubit({
    required this.getHotelsUseCase,
    required this.createHotelUseCase,
  }) : super(B2CHotelBookingsInitial());

  Future<void> getHotelBookings() async {
    emit(B2CHotelBookingsLoading());
    final result = await getHotelsUseCase();
    result.fold(
      (failure) => emit(B2CHotelBookingsError(failure.message)),
      (bookings) => emit(B2CHotelBookingsLoaded(bookings)),
    );
  }

  Future<void> createHotelBooking(B2CHotelBookingEntity booking) async {
    emit(B2CHotelBookingsLoading());
    final result = await createHotelUseCase(booking);
    result.fold(
      (failure) => emit(B2CHotelBookingsError(failure.message)),
      (newBooking) {
        emit(B2CHotelBookingCreated(newBooking));
        getHotelBookings(); // Refresh the list
      },
    );
  }
}
