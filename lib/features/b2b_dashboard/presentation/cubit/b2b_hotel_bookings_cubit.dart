import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/booking_entities.dart';
import '../../domain/usecases/get_hotels_bookings_usecase.dart';
import '../../domain/usecases/create_hotel_booking_usecase.dart';

part 'b2b_hotel_bookings_state.dart';

class B2BHotelBookingsCubit extends Cubit<B2BHotelBookingsState> {
  final GetB2BHotelsBookingsUseCase getHotelsUseCase;
  final CreateB2BHotelBookingUseCase createHotelUseCase;

  B2BHotelBookingsCubit({
    required this.getHotelsUseCase,
    required this.createHotelUseCase,
  }) : super(B2BHotelBookingsInitial());

  Future<void> getHotelsBookings() async {
    emit(B2BHotelBookingsLoading());
    final result = await getHotelsUseCase();
    result.fold(
      (failure) => emit(B2BHotelBookingsError(failure.message)),
      (bookings) => emit(B2BHotelBookingsLoaded(bookings)),
    );
  }

  Future<void> createHotelBooking(HotelBookingEntity booking) async {
    emit(B2BHotelBookingCreating());
    final result = await createHotelUseCase(booking);
    result.fold(
      (failure) => emit(B2BHotelBookingCreateError(failure.message)),
      (createdBooking) {
        emit(B2BHotelBookingCreated(createdBooking));
        getHotelsBookings();
      },
    );
  }
}
