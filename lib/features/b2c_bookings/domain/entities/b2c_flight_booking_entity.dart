import 'package:equatable/equatable.dart';

class B2CFlightBookingEntity extends Equatable {
  final String id;
  final String route;
  final DateTime date;
  final double price;
  final String status;
  final String customer;
  final String? airline;
  final String? flightNo;
  final String? fromCity;
  final String? toCity;
  final DateTime? departureTime;
  final DateTime? arrivalTime;
  final String? duration;

  const B2CFlightBookingEntity({
    required this.id,
    required this.route,
    required this.date,
    required this.price,
    required this.status,
    required this.customer,
    this.airline,
    this.flightNo,
    this.fromCity,
    this.toCity,
    this.departureTime,
    this.arrivalTime,
    this.duration,
  });

  @override
  List<Object?> get props => [
        id,
        route,
        date,
        price,
        status,
        customer,
        airline,
        flightNo,
        fromCity,
        toCity,
        departureTime,
        arrivalTime,
        duration,
      ];
}
