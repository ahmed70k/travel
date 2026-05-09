import '../../domain/entities/car_booking_entity.dart';

class CarBookingsResponseModel {
  final List<CarBookingModel> bookings;
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  CarBookingsResponseModel({
    required this.bookings,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory CarBookingsResponseModel.fromJson(Map<String, dynamic> json) {
    // Robust parsing: check if 'data' is the root or nested
    var listData = json['bookings'] ?? json['data'] ?? json['list'] ?? [];
    if (json is List) {
      listData = json;
    }

    return CarBookingsResponseModel(
      bookings: (listData as List)
          .map((item) => CarBookingModel.fromJson(item))
          .toList(),
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 1,
    );
  }
}

class CarBookingModel extends CarBookingEntity {
  const CarBookingModel({
    required super.id,
    required super.car,
    required super.fromCity,
    required super.toCity,
    required super.pickupDate,
    required super.returnDate,
    required super.duration,
    required super.price,
    required super.status,
    required super.customer,
  });

  factory CarBookingModel.fromJson(Map<String, dynamic> json) {
    return CarBookingModel(
      id: json['id']?.toString() ?? 'N/A',
      car: _cleanCarName(json['car']?.toString()),
      fromCity: _cleanCityName(json['fromCity']?.toString()),
      toCity: _cleanCityName(json['toCity']?.toString()),
      pickupDate: _parseDate(json['pickupDate']),
      returnDate: _parseDate(json['returnDate']),
      duration: json['duration']?.toString() ?? _calculateDuration(json['pickupDate'], json['returnDate']),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      status: json['status']?.toString().toLowerCase() ?? 'pending',
      customer: json['customer']?.toString() ?? 'غير معروف',
    );
  }

  factory CarBookingModel.fromEntity(CarBookingEntity entity) {
    return CarBookingModel(
      id: entity.id,
      car: entity.car,
      fromCity: entity.fromCity,
      toCity: entity.toCity,
      pickupDate: entity.pickupDate,
      returnDate: entity.returnDate,
      duration: entity.duration,
      price: entity.price,
      status: entity.status,
      customer: entity.customer,
    );
  }

  CarBookingEntity toEntity() {
    return CarBookingEntity(
      id: id,
      car: car,
      fromCity: fromCity,
      toCity: toCity,
      pickupDate: pickupDate,
      returnDate: returnDate,
      duration: duration,
      price: price,
      status: status,
      customer: customer,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'car': car,
      'fromCity': fromCity,
      'toCity': toCity,
      'route': '$fromCity - $toCity',
      'date': pickupDate.toIso8601String(),
      'pickupDate': pickupDate.toIso8601String(),
      'returnDate': returnDate.toIso8601String(),
      'duration': duration,
      'price': price,
      'status': status,
      'customer': customer,
    };
  }

  static String _cleanCarName(String? name) {
    if (name == null || name.trim().isEmpty || name.length < 2) return 'Car';
    // Remove common garbage or placeholder text if needed
    return name;
  }

  static String _cleanCityName(String? city) {
    if (city == null || city.trim().isEmpty) return '-';
    return city;
  }

  static DateTime _parseDate(dynamic dateStr) {
    if (dateStr == null) return DateTime.now();
    try {
      return DateTime.parse(dateStr.toString());
    } catch (_) {
      return DateTime.now();
    }
  }

  static String _calculateDuration(dynamic start, dynamic end) {
    if (start == null || end == null) return 'N/A';
    try {
      final s = DateTime.parse(start.toString());
      final e = DateTime.parse(end.toString());
      final days = e.difference(s).inDays;
      return '$days Day${days != 1 ? 's' : ''}';
    } catch (_) {
      return 'N/A';
    }
  }
}
