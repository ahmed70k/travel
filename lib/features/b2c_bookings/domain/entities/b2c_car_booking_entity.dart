import 'package:equatable/equatable.dart';

class B2CCarBookingEntity extends Equatable {
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

  const B2CCarBookingEntity({
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
  List<Object?> get props => [
        id,
        carModel,
        category,
        pickupLocation,
        pickupDate,
        returnLocation,
        returnDate,
        duration,
        totalPrice,
        status,
        customer,
      ];
}
