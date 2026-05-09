import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travle/features/admin/cars/domain/usecases/get_car_bookings_usecase.dart';
import 'package:travle/features/admin/cars/domain/entities/car_booking_entity.dart';
import 'package:travle/core/error/failures.dart';
import 'package:travle/features/admin/cars/presentation/cubit/car_bookings_state.dart';

class CarBookingsCubit extends Cubit<CarBookingsState> {
  final GetCarBookingsUseCase getCarBookingsUseCase;

  CarBookingsCubit(this.getCarBookingsUseCase) : super(const CarBookingsInitial());

  int _currentPage = 1;
  static const int _limit = 10;

  Future<void> fetchBookings({
    String? search,
    String? status,
    String sortBy = "pickupDate",
    String sortOrder = "desc",
    bool refresh = false,
  }) async {
    if (refresh) {
      _currentPage = 1;
      emit(const CarBookingsLoading());
    } else if (state is CarBookingsLoaded) {
      final current = state as CarBookingsLoaded;
      if (current.hasReachedMax) return;
      emit(CarBookingsLoadingMore(
        bookings: current.bookings,
        hasReachedMax: current.hasReachedMax,
        totalCount: current.totalCount,
        search: search ?? current.search,
        status: status ?? current.status,
        sortBy: sortBy,
        sortOrder: sortOrder,
      ));
    } else {
      emit(const CarBookingsLoading());
    }

    final result = await getCarBookingsUseCase(
      page: _currentPage,
      limit: _limit,
      search: search,
      status: status,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );

    result.fold(
      (Failure failure) => emit(CarBookingsError(failure.message)),
      (response) {
        final newBookings = response.bookings;
        final bool hasReachedMax = _currentPage >= response.totalPages;

        if (_currentPage == 1) {
          emit(CarBookingsLoaded(
            bookings: List<CarBookingEntity>.from(newBookings),
            hasReachedMax: hasReachedMax,
            totalCount: response.total,
            search: search,
            status: status,
            sortBy: sortBy,
            sortOrder: sortOrder,
          ));
        } else {
          final current = state as CarBookingsLoaded;
          final updatedBookings = List<CarBookingEntity>.from(current.bookings)
            ..addAll(newBookings);
          emit(CarBookingsLoaded(
            bookings: updatedBookings,
            hasReachedMax: hasReachedMax,
            totalCount: response.total,
            search: search ?? current.search,
            status: status ?? current.status,
            sortBy: sortBy,
            sortOrder: sortOrder,
          ));
        }
        _currentPage++;
      },
    );
  }

  void toggleSortOrder() {
    if (state is CarBookingsLoaded) {
      final current = state as CarBookingsLoaded;
      final newOrder = current.sortOrder == 'desc' ? 'asc' : 'desc';
      fetchBookings(
        search: current.search,
        status: current.status,
        sortBy: current.sortBy,
        sortOrder: newOrder,
        refresh: true,
      );
    }
  }

  void updateSearch(String query) {
    if (state is CarBookingsLoaded) {
      final current = state as CarBookingsLoaded;
      fetchBookings(
        search: query,
        status: current.status,
        sortBy: current.sortBy,
        sortOrder: current.sortOrder,
        refresh: true,
      );
    } else {
      fetchBookings(search: query, refresh: true);
    }
  }

  void updateStatus(String? status) {
    if (state is CarBookingsLoaded) {
      final current = state as CarBookingsLoaded;
      fetchBookings(
        search: current.search,
        status: status,
        sortBy: current.sortBy,
        sortOrder: current.sortOrder,
        refresh: true,
      );
    } else {
      fetchBookings(status: status, refresh: true);
    }
  }
}
