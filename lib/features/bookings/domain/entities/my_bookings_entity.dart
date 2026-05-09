import 'package:equatable/equatable.dart';

class BookingItemEntity extends Equatable {
  final String id;
  final String status;
  final double price;
  final String bookingType; // 'flight', 'hotel', 'car'
  final DateTime date;
  final String title;
  final String subtitle;

  const BookingItemEntity({
    required this.id,
    required this.status,
    required this.price,
    required this.bookingType,
    required this.date,
    required this.title,
    required this.subtitle,
  });

  @override
  List<Object?> get props => [id, status, price, bookingType, date, title, subtitle];
}

class MyBookingsEntity extends Equatable {
  final List<BookingItemEntity> flights;
  final List<BookingItemEntity> hotels;
  final List<BookingItemEntity> cars;
  final List<BookingItemEntity> allBookings;

  const MyBookingsEntity({
    required this.flights,
    required this.hotels,
    required this.cars,
    required this.allBookings,
  });

  @override
  List<Object?> get props => [flights, hotels, cars, allBookings];
}
