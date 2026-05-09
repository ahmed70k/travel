import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/usecases/get_flights_availability_usecase.dart';
import '../../../../core/error/failures.dart';
import 'package:equatable/equatable.dart';
import 'flights_availability_state.dart';

class FlightsAvailabilityCubit extends Cubit<FlightsAvailabilityState> {
  final GetFlightsAvailabilityUseCase getFlightsAvailabilityUseCase;

  FlightsAvailabilityCubit({required this.getFlightsAvailabilityUseCase})
      : super(FlightsAvailabilityInitial());

  Future<void> fetchAvailability({DateTime? from, DateTime? to}) async {
    emit(FlightsAvailabilityLoading());

    final String? fromStr = from != null ? DateFormat('yyyy-MM-dd').format(from) : null;
    final String? toStr = to != null ? DateFormat('yyyy-MM-dd').format(to) : null;

    final result = await getFlightsAvailabilityUseCase(from: fromStr, to: toStr);

    result.fold(
      (failure) => emit(FlightsAvailabilityError(failure.message)),
      (availability) => emit(FlightsAvailabilityLoaded(availability)),
    );
  }
}
