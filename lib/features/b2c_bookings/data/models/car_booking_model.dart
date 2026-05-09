import '../../domain/entities/b2c_car_booking_entity.dart';

class B2CCarBookingModel extends B2CCarBookingEntity {
  const B2CCarBookingModel({
    required super.id,
    required super.carModel,
    required super.category,
    required super.pickupLocation,
    required super.pickupDate,
    required super.returnLocation,
    required super.returnDate,
    required super.duration,
    required super.totalPrice,
    required super.status,
    required super.customer,
  });

  factory B2CCarBookingModel.fromJson(Map<String, dynamic> json) {
    return B2CCarBookingModel(
      id: json['id']?.toString() ?? '',
      carModel: json['carModel'] ?? json['car'] ?? '',
      category: json['category'] ?? '',
      pickupLocation: json['pickupLocation'] ?? json['fromCity'] ?? json['from'] ?? '',
      pickupDate: DateTime.tryParse(json['pickupDate'] ?? '') ?? DateTime.now(),
      returnLocation: json['returnLocation'] ?? json['toCity'] ?? json['to'] ?? '',
      returnDate: DateTime.tryParse(json['returnDate'] ?? '') ?? DateTime.now(),
      duration: json['duration'] ?? '',
      totalPrice: (json['totalPrice'] ?? json['price'] as num?)?.toDouble() ?? 0.0,
      status: json['status']?.toString() ?? 'pending',
      customer: json['customer']?.toString() ?? 'Default Customer',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'car': carModel,
      'category': category,
      'fromCity': pickupLocation,
      'pickupDate': pickupDate.toIso8601String(),
      'toCity': returnLocation,
      'returnDate': returnDate.toIso8601String(),
      'duration': duration,
      'price': totalPrice,
      'status': status,
      'customer': customer,
    };
  }

  factory B2CCarBookingModel.fromEntity(B2CCarBookingEntity entity) {
    return B2CCarBookingModel(
      id: entity.id,
      carModel: entity.carModel,
      category: entity.category,
      pickupLocation: entity.pickupLocation,
      pickupDate: entity.pickupDate,
      returnLocation: entity.returnLocation,
      returnDate: entity.returnDate,
      duration: entity.duration,
      totalPrice: entity.totalPrice,
      status: entity.status,
      customer: entity.customer,
    );
  }
}
