import 'package:equatable/equatable.dart';
import 'car_booking_entity.dart';

class CarKPIEntity extends Equatable {
  final int totalCarBookings;
  final double carRevenue;
  final double avgRentalDays;
  final int carPartners;
  final String? bookingsDelta;
  final String? revenueDelta;

  const CarKPIEntity({
    required this.totalCarBookings,
    required this.carRevenue,
    required this.avgRentalDays,
    required this.carPartners,
    this.bookingsDelta,
    this.revenueDelta,
  });

  @override
  List<Object?> get props => [
        totalCarBookings,
        carRevenue,
        avgRentalDays,
        carPartners,
        bookingsDelta,
        revenueDelta,
      ];
}

class CarFiltersEntity extends Equatable {
  final List<String> carTypes;
  final List<String> categories;

  const CarFiltersEntity({
    required this.carTypes,
    required this.categories,
  });

  @override
  List<Object?> get props => [carTypes, categories];
}



class AdminCarsEntity extends Equatable {
  final CarKPIEntity kpis;
  final CarFiltersEntity filters;
  final List<CarBookingEntity> bookings;
  final DateTime from;
  final DateTime to;

  const AdminCarsEntity({
    required this.kpis,
    required this.filters,
    required this.bookings,
    required this.from,
    required this.to,
  });

  @override
  List<Object?> get props => [kpis, filters, bookings, from, to];
}
