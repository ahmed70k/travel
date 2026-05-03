import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_admin_flights_usecase.dart';
import 'admin_flights_state.dart';

class AdminFlightsCubit extends Cubit<AdminFlightsState> {
  final GetAdminFlightsUseCase getAdminFlightsUseCase;

  AdminFlightsCubit(this.getAdminFlightsUseCase) : super(AdminFlightsInitial());

  DateTime? _currentFrom;
  DateTime? _currentTo;
  String? _currentTripType;
  String? _currentCategory;

  Future<void> getFlights({
    DateTime? from,
    DateTime? to,
    String? tripType,
    String? category,
    bool isRefresh = false,
  }) async {
    if (!isRefresh) emit(AdminFlightsLoading());

    _currentFrom = from ?? _currentFrom;
    _currentTo = to ?? _currentTo;
    _currentTripType = tripType ?? _currentTripType;
    _currentCategory = category ?? _currentCategory;

    final result = await getAdminFlightsUseCase(
      from: _currentFrom,
      to: _currentTo,
      tripType: _currentTripType,
      category: _currentCategory,
    );

    result.fold(
      (failure) => emit(AdminFlightsError(failure.message)),
      (data) => emit(AdminFlightsLoaded(data)),
    );
  }

  Future<void> refresh() => getFlights(isRefresh: true);
}
