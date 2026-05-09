import '../../domain/entities/availability_entity.dart';

class AvailabilityModel extends AvailabilityEntity {
  const AvailabilityModel({
    required super.booked,
    required super.capacity,
    required super.available,
    required super.hasAvailability,
  });

  factory AvailabilityModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return AvailabilityModel(
      booked: data['booked'] ?? 0,
      capacity: data['capacity'] ?? 0,
      available: data['available'] ?? 0,
      hasAvailability: data['hasAvailability'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'booked': booked,
      'capacity': capacity,
      'available': available,
      'hasAvailability': hasAvailability,
    };
  }
}
