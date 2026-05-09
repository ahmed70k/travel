import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/usecases/get_hotels_availability_usecase.dart';
import '../../../../core/error/failures.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/availability_entity.dart';

abstract class HotelsAvailabilityState extends Equatable {
  const HotelsAvailabilityState();
  @override
  List<Object?> get props => [];
}

class HotelsAvailabilityInitial extends HotelsAvailabilityState {}
class HotelsAvailabilityLoading extends HotelsAvailabilityState {}
class HotelsAvailabilityLoaded extends HotelsAvailabilityState {
  final AvailabilityEntity availability;
  const HotelsAvailabilityLoaded(this.availability);
  @override
  List<Object?> get props => [availability];
}
class HotelsAvailabilityError extends HotelsAvailabilityState {
  final String message;
  const HotelsAvailabilityError(this.message);
  @override
  List<Object?> get props => [message];
}

class HotelsAvailabilityCubit extends Cubit<HotelsAvailabilityState> {
  final GetHotelsAvailabilityUseCase getHotelsAvailabilityUseCase;

  HotelsAvailabilityCubit({required this.getHotelsAvailabilityUseCase})
      : super(HotelsAvailabilityInitial());

  Future<void> fetchAvailability({DateTime? from, DateTime? to}) async {
    emit(HotelsAvailabilityLoading());

    final String? fromStr = from != null ? DateFormat('yyyy-MM-dd').format(from) : null;
    final String? toStr = to != null ? DateFormat('yyyy-MM-dd').format(to) : null;

    final result = await getHotelsAvailabilityUseCase(from: fromStr, to: toStr);

    result.fold(
      (failure) => emit(HotelsAvailabilityError(failure.message)),
      (availability) => emit(HotelsAvailabilityLoaded(availability)),
    );
  }
}
