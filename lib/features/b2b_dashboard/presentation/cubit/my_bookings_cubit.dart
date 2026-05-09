import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_my_bookings_usecase.dart';
import '../../../../core/error/failures.dart';
import 'my_bookings_state.dart';

class B2BMyBookingsCubit extends Cubit<B2BMyBookingsState> {
  final GetMyBookingsUseCase getMyBookingsUseCase;

  B2BMyBookingsCubit({required this.getMyBookingsUseCase}) : super(B2BMyBookingsInitial());

  Future<void> getMyBookings({bool forceRefresh = false}) async {
    if (state is B2BMyBookingsLoading) return;
    if (!forceRefresh && state is B2BMyBookingsLoaded) return;

    emit(B2BMyBookingsLoading());
    final result = await getMyBookingsUseCase();
    result.fold(
      (failure) => emit(B2BMyBookingsError(failure.message)),
      (bookings) => emit(B2BMyBookingsLoaded(bookings)),
    );
  }
}
