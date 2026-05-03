// Dashboard Models

class StatModel {
  final String title;
  final String value;
  final String changeLabel;
  final bool isPositive;
  final double progress; // 0.0 to 1.0

  StatModel({
    required this.title,
    required this.value,
    required this.changeLabel,
    required this.isPositive,
    required this.progress,
  });
}

class BookingModel {
  final String id;
  final String clientName;
  final String flightPath;
  final String date;
  final String price;
  final BookingStatus status;

  BookingModel({
    required this.id,
    required this.clientName,
    required this.flightPath,
    required this.date,
    required this.price,
    required this.status,
  });
}

enum BookingStatus {
  pending,
  confirmed,
  issuing,
  issued,
  cancelled,
  payment_pending,
}

enum UserRole { admin, b2b, b2c }

class AdminUserModel {
  final String id;
  final String name;
  final String username;
  final String email;
  final String avatarUrl;
  final UserRole role;
  final String registrationDate;
  final int bookingCount;
  final bool isActive;
  final String? companyName;

  AdminUserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.avatarUrl,
    required this.role,
    required this.registrationDate,
    required this.bookingCount,
    required this.isActive,
    this.companyName,
  });
}

class HotelBooking {
  final String id;
  final String hotelName;
  final double stars;
  final String location;
  final String checkIn;
  final String checkOut;
  final String guests;
  final String roomType;
  final String price;
  final BookingStatus status;
  final String clientName;

  HotelBooking({
    required this.id,
    required this.hotelName,
    required this.stars,
    required this.location,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.roomType,
    required this.price,
    required this.status,
    required this.clientName,
  });
}

class CarBooking {
  final String id;
  final String carModel;
  final String category; // فاخرة، SUV، إلخ
  final String fuelType;
  final String pickupLocation;
  final String pickupDate;
  final String returnLocation;
  final String returnDate;
  final String duration;
  final String totalPrice;
  final BookingStatus status;
  final String clientName;
  final bool withDriver;

  CarBooking({
    required this.id,
    required this.carModel,
    required this.category,
    required this.fuelType,
    required this.pickupLocation,
    required this.pickupDate,
    required this.returnLocation,
    required this.returnDate,
    required this.duration,
    required this.totalPrice,
    required this.status,
    required this.clientName,
    this.withDriver = false,
  });
}

class DetailedFlightBooking {
  final String id;
  final String airlineName;
  final String airlineCode;
  final String flightType; // e.g. Direct
  final String departureTime;
  final String departureAirport;
  final String arrivalTime;
  final String arrivalAirport;
  final String duration;
  final String price;
  final BookingStatus status;
  final String passengerName;
  final int passengerCount;
  final String flightClass; // e.g. Economy, Business

  DetailedFlightBooking({
    required this.id,
    required this.airlineName,
    required this.airlineCode,
    required this.flightType,
    required this.departureTime,
    required this.departureAirport,
    required this.arrivalTime,
    required this.arrivalAirport,
    required this.duration,
    required this.price,
    required this.status,
    required this.passengerName,
    required this.passengerCount,
    required this.flightClass,
  });
}

class ProviderModel {
  final String name;
  final String type;
  final String apiKeyPartial;
  final int requestsToday;
  final ProviderStatus status;

  ProviderModel({
    required this.name,
    required this.type,
    required this.apiKeyPartial,
    required this.requestsToday,
    required this.status,
  });
}

enum ProviderStatus { active, trial }

class OfferModel {
  final String name;
  final String type;
  final String discount;
  final String period;
  final bool isActive;

  OfferModel({
    required this.name,
    required this.type,
    required this.discount,
    required this.period,
    required this.isActive,
  });
}

class TopB2bModel {
  final String name;
  final String bookings;
  final String revenue;

  TopB2bModel({
    required this.name,
    required this.bookings,
    required this.revenue,
  });
}
