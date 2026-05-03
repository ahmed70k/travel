import 'package:equatable/equatable.dart';

class FlightKPIEntity extends Equatable {
  final int totalFlightBookings;
  final double flightRevenue;
  final double occupancyRate;
  final int partnerAirlines;
  final String? bookingsDelta;
  final String? revenueDelta;

  const FlightKPIEntity({
    required this.totalFlightBookings,
    required this.flightRevenue,
    required this.occupancyRate,
    required this.partnerAirlines,
    this.bookingsDelta,
    this.revenueDelta,
  });

  @override
  List<Object?> get props => [
        totalFlightBookings,
        flightRevenue,
        occupancyRate,
        partnerAirlines,
        bookingsDelta,
        revenueDelta,
      ];
}

class FlightFiltersEntity extends Equatable {
  final List<String> tripType;
  final List<String> categories;

  const FlightFiltersEntity({
    required this.tripType,
    required this.categories,
  });

  @override
  List<Object?> get props => [tripType, categories];
}

class FlightBookingEntity extends Equatable {
  final String id;
  final String? airline;
  final String? flightNo;
  final String? from;
  final String? to;
  final DateTime? departureTime;
  final DateTime? arrivalTime;
  final String? duration;
  final String customer;
  final double price;
  final String status; // confirmed / pending / cancelled
  final DateTime? updatedAt;

  const FlightBookingEntity({
    required this.id,
    this.airline,
    this.flightNo,
    this.from,
    this.to,
    this.departureTime,
    this.arrivalTime,
    this.duration,
    required this.customer,
    required this.price,
    required this.status,
    this.updatedAt,
  });

  String? get route => (from != null && to != null) ? '$from ➔ $to' : null;

  @override
  List<Object?> get props => [
        id,
        airline,
        flightNo,
        from,
        to,
        departureTime,
        arrivalTime,
        duration,
        customer,
        price,
        status,
        updatedAt,
      ];
}

class AdminFlightsEntity extends Equatable {
  final FlightKPIEntity kpis;
  final FlightFiltersEntity filters;
  final List<FlightBookingEntity> bookings;
  final DateTime from;
  final DateTime to;

  const AdminFlightsEntity({
    required this.kpis,
    required this.filters,
    required this.bookings,
    required this.from,
    required this.to,
  });

  @override
  List<Object?> get props => [kpis, filters, bookings, from, to];
}
