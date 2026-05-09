import 'package:equatable/equatable.dart';
import '../../domain/entities/car_booking_entity.dart';

abstract class CarBookingsState extends Equatable {
  const CarBookingsState();

  @override
  List<Object?> get props => [];
}

class CarBookingsInitial extends CarBookingsState {
  const CarBookingsInitial();
}

class CarBookingsLoading extends CarBookingsState {
  const CarBookingsLoading();
}

class CarBookingsLoaded extends CarBookingsState {
  final List<CarBookingEntity> bookings;
  final bool hasReachedMax;
  final int totalCount;
  final String? search;
  final String? status;
  final String sortBy;
  final String sortOrder;

  const CarBookingsLoaded({
    required this.bookings,
    required this.hasReachedMax,
    required this.totalCount,
    this.search,
    this.status,
    required this.sortBy,
    required this.sortOrder,
  });

  CarBookingsLoaded copyWith({
    List<CarBookingEntity>? bookings,
    bool? hasReachedMax,
    int? totalCount,
    String? search,
    String? status,
    String? sortBy,
    String? sortOrder,
  }) {
    return CarBookingsLoaded(
      bookings: bookings ?? this.bookings,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      totalCount: totalCount ?? this.totalCount,
      search: search ?? this.search,
      status: status ?? this.status,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  List<Object?> get props => [bookings, hasReachedMax, totalCount, search, status, sortBy, sortOrder];
}

class CarBookingsLoadingMore extends CarBookingsLoaded {
  const CarBookingsLoadingMore({
    required super.bookings,
    required super.hasReachedMax,
    required super.totalCount,
    super.search,
    super.status,
    required super.sortBy,
    required super.sortOrder,
  });
}

class CarBookingsError extends CarBookingsState {
  final String message;
  const CarBookingsError(this.message);

  @override
  List<Object?> get props => [message];
}
