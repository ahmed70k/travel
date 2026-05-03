import 'package:equatable/equatable.dart';

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

class CarBookingEntity extends Equatable {
  final String id;
  final String car;
  final String from;
  final String to;
  final DateTime pickupDate;
  final DateTime returnDate;
  final String duration;
  final double price;
  final String status; // confirmed / pending / cancelled
  final String? customer;

  const CarBookingEntity({
    required this.id,
    required this.car,
    required this.from,
    required this.to,
    required this.pickupDate,
    required this.returnDate,
    required this.duration,
    required this.price,
    required this.status,
    this.customer,
  });

  String get route => '$from ➔ $to';

  @override
  List<Object?> get props => [
        id,
        car,
        from,
        to,
        pickupDate,
        returnDate,
        duration,
        price,
        status,
        customer,
      ];
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
