import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_hotel_booking_usecase.dart';
import '../../data/models/create_hotel_booking_request.dart';
import '../../../../../core/error/failures.dart';
import 'create_hotel_booking_state.dart';

class CreateHotelBookingCubit extends Cubit<CreateHotelBookingState> {
  final CreateHotelBookingUseCase createHotelBookingUseCase;

  CreateHotelBookingCubit(this.createHotelBookingUseCase) : super(const CreateHotelBookingInitial());

  Future<void> createBooking(CreateHotelBookingRequest request) async {
    emit(const CreateHotelBookingLoading());

    final result = await createHotelBookingUseCase(request);

    result.fold(
      (Failure failure) => emit(CreateHotelBookingError(failure.message)),
      (booking) => emit(CreateHotelBookingSuccess(booking)),
    );
  }

  void reset() {
    emit(const CreateHotelBookingInitial());
  }
}
