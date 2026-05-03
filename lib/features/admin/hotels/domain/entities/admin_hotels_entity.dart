import 'package:equatable/equatable.dart';

class HotelKPIEntity extends Equatable {
  final int totalHotelBookings;
  final double hotelRevenue;
  final double avgOccupancy;
  final int hotelPartners;
  final String? bookingsDelta;
  final String? revenueDelta;

  const HotelKPIEntity({
    required this.totalHotelBookings,
    required this.hotelRevenue,
    required this.avgOccupancy,
    required this.hotelPartners,
    this.bookingsDelta,
    this.revenueDelta,
  });

  @override
  List<Object?> get props => [
        totalHotelBookings,
        hotelRevenue,
        avgOccupancy,
        hotelPartners,
        bookingsDelta,
        revenueDelta,
      ];
}

class HotelFiltersEntity extends Equatable {
  final List<String> guestsCount;
  final List<String> categories;

  const HotelFiltersEntity({
    required this.guestsCount,
    required this.categories,
  });

  @override
  List<Object?> get props => [guestsCount, categories];
}

class HotelBookingEntity extends Equatable {
  final String id;
  final String hotel;
  final String city;
  final DateTime checkIn;
  final DateTime checkOut;
  final String guests;
  final double price;
  final String status; // confirmed / pending / cancelled
  final DateTime? updatedAt;
  final String customer;

  const HotelBookingEntity({
    required this.id,
    required this.hotel,
    required this.city,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.price,
    required this.status,
    this.updatedAt,
    required this.customer,
  });

  @override
  List<Object?> get props => [
        id,
        hotel,
        city,
        checkIn,
        checkOut,
        guests,
        price,
        status,
        updatedAt,
        customer,
      ];
}

class AdminHotelsEntity extends Equatable {
  final HotelKPIEntity kpis;
  final HotelFiltersEntity filters;
  final List<HotelBookingEntity> bookings;
  final DateTime from;
  final DateTime to;

  const AdminHotelsEntity({
    required this.kpis,
    required this.filters,
    required this.bookings,
    required this.from,
    required this.to,
  });

  @override
  List<Object?> get props => [kpis, filters, bookings, from, to];
}
