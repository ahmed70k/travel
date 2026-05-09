import 'package:equatable/equatable.dart';

class B2CHotelBookingEntity extends Equatable {
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

  const B2CHotelBookingEntity({
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
  List<Object?> get props => [
        id,
        hotelName,
        location,
        checkIn,
        checkOut,
        guests,
        roomType,
        price,
        status,
        customer,
      ];
}
