import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/my_bookings_entity.dart';
import '../../domain/usecases/get_my_bookings_usecase.dart';

abstract class MyBookingsState extends Equatable {
  const MyBookingsState();
  @override
  List<Object?> get props => [];
}

class MyBookingsInitial extends MyBookingsState {}

class MyBookingsLoading extends MyBookingsState {}

class MyBookingsLoaded extends MyBookingsState {
  final MyBookingsEntity bookings;
  const MyBookingsLoaded(this.bookings);
  @override
  List<Object?> get props => [bookings];
}

class MyBookingsError extends MyBookingsState {
  final String message;
  const MyBookingsError(this.message);
  @override
  List<Object?> get props => [message];
}

class MyBookingsCubit extends Cubit<MyBookingsState> {
  final GetMyBookingsUseCase getMyBookingsUseCase;

  MyBookingsCubit(this.getMyBookingsUseCase) : super(MyBookingsInitial());

  Future<void> getMyBookings({bool forceRefresh = false}) async {
    if (state is MyBookingsLoading) return;
    if (!forceRefresh && state is MyBookingsLoaded) return;

    emit(MyBookingsLoading());
    final result = await getMyBookingsUseCase();
    result.fold(
      (failure) => emit(MyBookingsError(failure.message)),
      (bookings) => emit(MyBookingsLoaded(bookings)),
    );
  }
}
