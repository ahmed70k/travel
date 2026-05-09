import '../../domain/entities/b2c_hotel_booking_entity.dart';

class B2CHotelBookingModel extends B2CHotelBookingEntity {
  const B2CHotelBookingModel({
    required super.id,
    required super.hotelName,
    required super.location,
    required super.checkIn,
    required super.checkOut,
    required super.guests,
    required super.roomType,
    required super.price,
    required super.status,
    required super.customer,
  });

  factory B2CHotelBookingModel.fromJson(Map<String, dynamic> json) {
    return B2CHotelBookingModel(
      id: json['id']?.toString() ?? '',
      hotelName: json['hotelName'] ?? json['hotel'] ?? '',
      location: json['location'] ?? json['city'] ?? '',
      checkIn: DateTime.tryParse(json['checkIn'] ?? '') ?? DateTime.now(),
      checkOut: DateTime.tryParse(json['checkOut'] ?? '') ?? DateTime.now(),
      guests: json['guests']?.toString() ?? '1',
      roomType: json['roomType'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      status: json['status']?.toString() ?? 'pending',
      customer: json['customer']?.toString() ?? 'Default Customer',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hotel': hotelName,
      'city': location,
      'checkIn': checkIn.toIso8601String(),
      'checkOut': checkOut.toIso8601String(),
      'guests': guests,
      'roomType': roomType,
      'price': price,
      'status': status,
      'customer': customer,
    };
  }

  factory B2CHotelBookingModel.fromEntity(B2CHotelBookingEntity entity) {
    return B2CHotelBookingModel(
      id: entity.id,
      hotelName: entity.hotelName,
      location: entity.location,
      checkIn: entity.checkIn,
      checkOut: entity.checkOut,
      guests: entity.guests,
      roomType: entity.roomType,
      price: entity.price,
      status: entity.status,
      customer: entity.customer,
    );
  }
}
