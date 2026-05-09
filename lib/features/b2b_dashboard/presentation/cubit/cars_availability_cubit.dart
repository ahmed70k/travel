import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/availability_entity.dart';
import '../../domain/usecases/get_cars_availability_usecase.dart';
import '../../../../core/error/failures.dart';

abstract class CarsAvailabilityState extends Equatable {
  const CarsAvailabilityState();
  @override
  List<Object?> get props => [];
}

class CarsAvailabilityInitial extends CarsAvailabilityState {}
class CarsAvailabilityLoading extends CarsAvailabilityState {}
class CarsAvailabilityLoaded extends CarsAvailabilityState {
  final AvailabilityEntity availability;
  const CarsAvailabilityLoaded(this.availability);
  @override
  List<Object?> get props => [availability];
}
class CarsAvailabilityError extends CarsAvailabilityState {
  final String message;
  const CarsAvailabilityError(this.message);
  @override
  List<Object?> get props => [message];
}

class CarsAvailabilityCubit extends Cubit<CarsAvailabilityState> {
  final GetCarsAvailabilityUseCase getCarsAvailabilityUseCase;

  CarsAvailabilityCubit({required this.getCarsAvailabilityUseCase})
      : super(CarsAvailabilityInitial());

  Future<void> fetchAvailability({DateTime? from, DateTime? to}) async {
    emit(CarsAvailabilityLoading());

    final String? fromStr = from != null ? DateFormat('yyyy-MM-dd').format(from) : null;
    final String? toStr = to != null ? DateFormat('yyyy-MM-dd').format(to) : null;

    final result = await getCarsAvailabilityUseCase(from: fromStr, to: toStr);

    result.fold(
      (failure) => emit(CarsAvailabilityError(failure.message)),
      (availability) => emit(CarsAvailabilityLoaded(availability)),
    );
  }
}
