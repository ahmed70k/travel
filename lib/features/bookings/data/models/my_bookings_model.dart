import '../../domain/entities/my_bookings_entity.dart';

class MyBookingsResponseModel {
  final bool success;
  final String message;
  final MyBookingsDataModel data;

  MyBookingsResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory MyBookingsResponseModel.fromJson(Map<String, dynamic> json) {
    return MyBookingsResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: MyBookingsDataModel.fromJson(json['data'] ?? {}),
    );
  }
}

class MyBookingsDataModel {
  final List<BookingItemModel> flights;
  final List<BookingItemModel> hotels;
  final List<BookingItemModel> cars;

  MyBookingsDataModel({
    required this.flights,
    required this.hotels,
    required this.cars,
  });

  factory MyBookingsDataModel.fromJson(Map<String, dynamic> json) {
    return MyBookingsDataModel(
      flights: (json['flights'] as List? ?? [])
          .map((e) => BookingItemModel.fromJson(e, 'flight'))
          .toList(),
      hotels: (json['hotels'] as List? ?? [])
          .map((e) => BookingItemModel.fromJson(e, 'hotel'))
          .toList(),
      cars: (json['cars'] as List? ?? [])
          .map((e) => BookingItemModel.fromJson(e, 'car'))
          .toList(),
    );
  }

  MyBookingsEntity toEntity() {
    final flightEntities = flights.map((e) => e.toEntity()).toList();
    final hotelEntities = hotels.map((e) => e.toEntity()).toList();
    final carEntities = cars.map((e) => e.toEntity()).toList();

    final all = [...flightEntities, ...hotelEntities, ...carEntities];
    all.sort((a, b) => b.date.compareTo(a.date)); // Recent first

    return MyBookingsEntity(
      flights: flightEntities,
      hotels: hotelEntities,
      cars: carEntities,
      allBookings: all,
    );
  }
}

class BookingItemModel {
  final String id;
  final String status;
  final double price;
  final String bookingType;
  final DateTime date;
  final String title;
  final String subtitle;

  BookingItemModel({
    required this.id,
    required this.status,
    required this.price,
    required this.bookingType,
    required this.date,
    required this.title,
    required this.subtitle,
  });

  factory BookingItemModel.fromJson(Map<String, dynamic> json, String type) {
    String title = '';
    String subtitle = '';
    DateTime date = DateTime.now();

    if (type == 'flight') {
      title = json['airline'] ?? 'Flight';
      subtitle = json['route'] ?? '${json['fromCity'] ?? ''} - ${json['toCity'] ?? ''}';
      date = DateTime.tryParse(json['date'] ?? '') ?? DateTime.now();
    } else if (type == 'hotel') {
      title = json['hotelName'] ?? json['hotel'] ?? 'Hotel';
      subtitle = json['location'] ?? json['city'] ?? 'Location';
      date = DateTime.tryParse(json['checkIn'] ?? '') ?? DateTime.now();
    } else if (type == 'car') {
      title = json['carModel'] ?? json['car'] ?? 'Car';
      subtitle = json['pickupLocation'] ?? json['fromCity'] ?? 'Location';
      date = DateTime.tryParse(json['pickupDate'] ?? '') ?? DateTime.now();
    }

    return BookingItemModel(
      id: json['id'] ?? '',
      status: json['status'] ?? 'pending',
      price: (json['price'] ?? json['totalPrice'] ?? 0).toDouble(),
      bookingType: type,
      date: date,
      title: title,
      subtitle: subtitle,
    );
  }

  BookingItemEntity toEntity() {
    return BookingItemEntity(
      id: id,
      status: status,
      price: price,
      bookingType: bookingType,
      date: date,
      title: title,
      subtitle: subtitle,
    );
  }
}
