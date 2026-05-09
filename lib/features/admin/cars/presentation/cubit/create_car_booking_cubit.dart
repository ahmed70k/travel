import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/car_booking_entity.dart';
import '../../domain/usecases/create_car_booking_usecase.dart';
import 'create_car_booking_state.dart';

class CreateCarBookingCubit extends Cubit<CreateCarBookingState> {
  final CreateCarBookingUseCase createCarBookingUseCase;

  CreateCarBookingCubit(this.createCarBookingUseCase) : super(CreateCarBookingInitial());

  Future<void> createBooking({
    required String car,
    required String fromCity,
    required String toCity,
    required DateTime pickupDate,
    required DateTime returnDate,
    required double price,
    required String status,
    required String customer,
  }) async {
    emit(CreateCarBookingLoading());

    // Generate a temporary ID or use one if required by API
    final id = "C-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}";

    final booking = CarBookingEntity(
      id: id,
      car: car,
      fromCity: fromCity,
      toCity: toCity,
      pickupDate: pickupDate,
      returnDate: returnDate,
      duration: "${returnDate.difference(pickupDate).inDays} Days",
      price: price,
      status: status,
      customer: customer,
    );

    final result = await createCarBookingUseCase(booking);

    result.fold(
      (failure) => emit(CreateCarBookingError(failure.message)),
      (booking) => emit(CreateCarBookingSuccess(booking)),
    );
  }

  void reset() {
    emit(CreateCarBookingInitial());
  }
}
