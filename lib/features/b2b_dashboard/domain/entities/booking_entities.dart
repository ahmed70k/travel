import 'package:equatable/equatable.dart';

class MyBookingsEntity extends Equatable {
  final List<FlightBookingEntity> flights;
  final List<HotelBookingEntity> hotels;
  final List<CarBookingEntity> cars;

  const MyBookingsEntity({
    required this.flights,
    required this.hotels,
    required this.cars,
  });

  @override
  List<Object?> get props => [flights, hotels, cars];
}

class FlightBookingEntity extends Equatable {
  final String id;
  final String airlineName;
  final String airlineCode;
  final String flightType;
  final String from;
  final String to;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final String duration;
  final double price;
  final String status;
  final String customer;

  const FlightBookingEntity({
    required this.id,
    required this.airlineName,
    required this.airlineCode,
    required this.flightType,
    required this.from,
    required this.to,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.price,
    required this.status,
    required this.customer,
  });

  @override
  List<Object?> get props => [id, airlineName, airlineCode, from, to, departureTime, arrivalTime, price, status, customer];
}

class HotelBookingEntity extends Equatable {
  final String id;
  final String hotelName;
  final String location;
  final DateTime checkIn;
  final DateTime checkOut;
  final String guests;
  final String roomType;
  final double price;
  final String status;
  final String customer;

  String get city => location;

  const HotelBookingEntity({
    required this.id,
    required this.hotelName,
    required this.location,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.roomType,
    required this.price,
    required this.status,
    required this.customer,
  });

  @override
  List<Object?> get props => [id, hotelName, location, checkIn, checkOut, guests, roomType, price, status, customer];
}

class CarBookingEntity extends Equatable {
  final String id;
  final String carModel;
  final String category;
  final String pickupLocation;
  final DateTime pickupDate;
  final String returnLocation;
  final DateTime returnDate;
  final String duration;
  final double totalPrice;
  final String status;
  final String customer;

  String get carName => carModel;

  const CarBookingEntity({
    required this.id,
    required this.carModel,
    required this.category,
    required this.pickupLocation,
    required this.pickupDate,
    required this.returnLocation,
    required this.returnDate,
    required this.duration,
    required this.totalPrice,
    required this.status,
    required this.customer,
  });

  @override
  List<Object?> get props => [id, carModel, category, pickupLocation, pickupDate, returnLocation, returnDate, totalPrice, status, customer];
}
