import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/admin_flights_entity.dart';
import '../../domain/usecases/create_flight_booking_usecase.dart';

part 'create_flight_booking_state.dart';

class CreateFlightBookingCubit extends Cubit<CreateFlightBookingState> {
  final CreateFlightBookingUseCase createFlightBookingUseCase;

  CreateFlightBookingCubit(this.createFlightBookingUseCase) : super(CreateFlightBookingInitial());

  Future<void> createFlightBooking(FlightBookingEntity booking) async {
    emit(CreateFlightBookingLoading());

    final result = await createFlightBookingUseCase(booking);

    result.fold(
      (failure) => emit(CreateFlightBookingError(failure.message)),
      (booking) => emit(CreateFlightBookingSuccess(booking)),
    );
  }
}
