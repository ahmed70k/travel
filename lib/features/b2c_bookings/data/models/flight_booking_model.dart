import '../../domain/entities/b2c_flight_booking_entity.dart';

class B2CFlightBookingModel extends B2CFlightBookingEntity {
  const B2CFlightBookingModel({
    required super.id,
    required super.route,
    required super.date,
    required super.price,
    required super.status,
    required super.customer,
    super.airline,
    super.flightNo,
    super.fromCity,
    super.toCity,
    super.departureTime,
    super.arrivalTime,
    super.duration,
  });

  factory B2CFlightBookingModel.fromJson(Map<String, dynamic> json) {
    return B2CFlightBookingModel(
      id: json['id']?.toString() ?? '',
      route: json['route']?.toString() ?? 'Unknown',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      price: (json['price'] ?? 0.0).toDouble(),
      status: json['status']?.toString() ?? 'pending',
      customer: json['customer']?.toString() ?? 'Default Customer',
      airline: json['airline'],
      flightNo: json['flightNo'],
      fromCity: json['fromCity'],
      toCity: json['toCity'],
      departureTime: DateTime.tryParse(json['departureTime'] ?? ''),
      arrivalTime: DateTime.tryParse(json['arrivalTime'] ?? ''),
      duration: json['duration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'route': route,
      'date': date.toIso8601String(),
      'price': price,
      'status': status,
      'customer': customer,
      'airline': airline,
      'flightNo': flightNo,
      'fromCity': fromCity,
      'toCity': toCity,
      'departureTime': departureTime?.toIso8601String(),
      'arrivalTime': arrivalTime?.toIso8601String(),
      'duration': duration,
    };
  }

  factory B2CFlightBookingModel.fromEntity(B2CFlightBookingEntity entity) {
    return B2CFlightBookingModel(
      id: entity.id,
      route: entity.route,
      date: entity.date,
      price: entity.price,
      status: entity.status,
      customer: entity.customer,
      airline: entity.airline,
      flightNo: entity.flightNo,
      fromCity: entity.fromCity,
      toCity: entity.toCity,
      departureTime: entity.departureTime,
      arrivalTime: entity.arrivalTime,
      duration: entity.duration,
    );
  }
}
