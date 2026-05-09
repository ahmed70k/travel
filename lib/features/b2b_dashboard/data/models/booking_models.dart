import '../../domain/entities/booking_entities.dart';

class MyBookingsModel extends MyBookingsEntity {
  const MyBookingsModel({
    required super.flights,
    required super.hotels,
    required super.cars,
  });

  factory MyBookingsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    
    // Case 1: Categorized structure
    if (data is Map<String, dynamic> && (data.containsKey('flights') || data.containsKey('hotels') || data.containsKey('cars'))) {
      return MyBookingsModel(
        flights: (data['flights'] as List?)?.map((e) => FlightBookingModel.fromJson(e)).toList() ?? [],
        hotels: (data['hotels'] as List?)?.map((e) => HotelBookingModel.fromJson(e)).toList() ?? [],
        cars: (data['cars'] as List?)?.map((e) => CarBookingModel.fromJson(e)).toList() ?? [],
      );
    }
    
    // Case 2: Flat list
    if (data is List) {
      final flights = <FlightBookingModel>[];
      final hotels = <HotelBookingModel>[];
      final cars = <CarBookingModel>[];
      
      for (var item in data) {
        final type = item['type']?.toString().toLowerCase() ?? '';
        if (type.contains('flight')) {
          flights.add(FlightBookingModel.fromJson(item));
        } else if (type.contains('hotel')) {
          hotels.add(HotelBookingModel.fromJson(item));
        } else if (type.contains('car')) {
          cars.add(CarBookingModel.fromJson(item));
        }
      }
      return MyBookingsModel(flights: flights, hotels: hotels, cars: cars);
    }

    return const MyBookingsModel(flights: [], hotels: [], cars: []);
  }
}

class FlightBookingModel extends FlightBookingEntity {
  const FlightBookingModel({
    required super.id,
    required super.airlineName,
    required super.airlineCode,
    required super.flightType,
    required super.from,
    required super.to,
    required super.departureTime,
    required super.arrivalTime,
    required super.duration,
    required super.price,
    required super.status,
    required super.customer,
  });

  factory FlightBookingModel.fromJson(Map<String, dynamic> json) {
    return FlightBookingModel(
      id: json['id']?.toString() ?? '',
      airlineName: json['airlineName'] ?? json['airline'] ?? '',
      airlineCode: json['airlineCode'] ?? json['flightNo'] ?? '',
      flightType: json['flightType'] ?? 'Direct',
      from: json['from'] ?? json['departureAirport'] ?? '',
      to: json['to'] ?? json['arrivalAirport'] ?? '',
      departureTime: DateTime.tryParse(json['departureTime'] ?? json['date'] ?? '') ?? DateTime.now(),
      arrivalTime: DateTime.tryParse(json['arrivalTime'] ?? '') ?? DateTime.now(),
      duration: json['duration'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      status: json['status']?.toString() ?? 'pending',
      customer: json['customer']?.toString() ?? 'B2B Agent',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.isEmpty ? 'FL-${DateTime.now().millisecondsSinceEpoch % 100000}' : id,
      'airline': airlineName,
      'airlineCode': airlineCode,
      'flightNo': airlineCode,
      'flightType': flightType,
      'from': from,
      'fromCity': from,
      'to': to,
      'toCity': to,
      'route': '$from - $to',
      'departureTime': departureTime.toIso8601String(),
      'date': departureTime.toIso8601String(),
      'arrivalTime': arrivalTime.toIso8601String(),
      'duration': duration,
      'price': price,
      'status': status.toLowerCase(),
      'customer': customer,
    };
  }

  factory FlightBookingModel.fromEntity(FlightBookingEntity entity) {
    return FlightBookingModel(
      id: entity.id,
      airlineName: entity.airlineName,
      airlineCode: entity.airlineCode,
      flightType: entity.flightType,
      from: entity.from,
      to: entity.to,
      departureTime: entity.departureTime,
      arrivalTime: entity.arrivalTime,
      duration: entity.duration,
      price: entity.price,
      status: entity.status,
      customer: entity.customer,
    );
  }
}

class HotelBookingModel extends HotelBookingEntity {
  const HotelBookingModel({
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

  factory HotelBookingModel.fromJson(Map<String, dynamic> json) {
    return HotelBookingModel(
      id: json['id']?.toString() ?? '',
      hotelName: json['hotelName'] ?? json['hotel'] ?? '',
      location: json['location'] ?? json['city'] ?? '',
      checkIn: DateTime.tryParse(json['checkIn'] ?? '') ?? DateTime.now(),
      checkOut: DateTime.tryParse(json['checkOut'] ?? '') ?? DateTime.now(),
      guests: json['guests']?.toString() ?? '1',
      roomType: json['roomType'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      status: json['status']?.toString() ?? 'pending',
      customer: json['customer']?.toString() ?? 'B2B Agent',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.isEmpty ? 'H-${DateTime.now().millisecondsSinceEpoch % 100000}' : id,
      'hotel': hotelName,
      'hotelName': hotelName,
      'location': location,
      'city': location,
      'checkIn': checkIn.toIso8601String(),
      'checkOut': checkOut.toIso8601String(),
      'guests': guests,
      'roomType': roomType,
      'price': price,
      'status': status.toLowerCase(),
      'customer': customer,
    };
  }

  factory HotelBookingModel.fromEntity(HotelBookingEntity entity) {
    return HotelBookingModel(
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

class CarBookingModel extends CarBookingEntity {
  const CarBookingModel({
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

  factory CarBookingModel.fromJson(Map<String, dynamic> json) {
    return CarBookingModel(
      id: json['id']?.toString() ?? '',
      carModel: json['carModel'] ?? json['car'] ?? '',
      category: json['category'] ?? '',
      pickupLocation: json['pickupLocation'] ?? json['from'] ?? '',
      pickupDate: DateTime.tryParse(json['pickupDate'] ?? '') ?? DateTime.now(),
      returnLocation: json['returnLocation'] ?? json['to'] ?? '',
      returnDate: DateTime.tryParse(json['returnDate'] ?? '') ?? DateTime.now(),
      duration: json['duration'] ?? '',
      totalPrice: (json['totalPrice'] ?? json['price'] as num?)?.toDouble() ?? 0.0,
      status: json['status']?.toString() ?? 'pending',
      customer: json['customer']?.toString() ?? 'B2B Agent',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.isEmpty ? 'C-${DateTime.now().millisecondsSinceEpoch % 100000}' : id,
      'car': carModel,
      'carModel': carModel,
      'category': category,
      'fromCity': pickupLocation,
      'pickupLocation': pickupLocation,
      'pickupDate': pickupDate.toIso8601String(),
      'toCity': returnLocation,
      'returnLocation': returnLocation,
      'returnDate': returnDate.toIso8601String(),
      'duration': duration,
      'price': totalPrice,
      'totalPrice': totalPrice,
      'status': status.toLowerCase(),
      'customer': customer,
    };
  }

  factory CarBookingModel.fromEntity(CarBookingEntity entity) {
    return CarBookingModel(
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
