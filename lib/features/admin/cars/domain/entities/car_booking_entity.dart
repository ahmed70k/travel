import 'package:equatable/equatable.dart';

class CarBookingEntity extends Equatable {
  final String id;
  final String car;
  final String fromCity;
  final String toCity;
  final DateTime pickupDate;
  final DateTime returnDate;
  final String duration;
  final double price;
  final String status;
  final String customer;

  const CarBookingEntity({
    required this.id,
    required this.car,
    required this.fromCity,
    required this.toCity,
    required this.pickupDate,
    required this.returnDate,
    required this.duration,
    required this.price,
    required this.status,
    required this.customer,
  });

  String get route => '$fromCity ➔ $toCity';

  @override
  List<Object?> get props => [
        id,
        car,
        fromCity,
        toCity,
        pickupDate,
        returnDate,
        duration,
        price,
        status,
        customer,
      ];
}
