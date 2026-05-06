import '../../domain/entities/admin_cars_entity.dart';

class AdminCarsModel extends AdminCarsEntity {
  const AdminCarsModel({
    required super.kpis,
    required super.filters,
    required super.bookings,
    required super.from,
    required super.to,
  });

  factory AdminCarsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    final kpisJson = data['kpis'] ?? {};
    final filtersJson = data['filters'] ?? {};
    final bookingsJson = (data['activeBookings'] as List?) ?? (data['bookings'] as List?) ?? [];
    final dateRangeJson = data['dateRange'] ?? {};

    return AdminCarsModel(
      kpis: CarKPIModel.fromJson(kpisJson),
      filters: CarFiltersModel.fromJson(filtersJson),
      bookings: bookingsJson
          .map((e) => CarBookingModel.fromJson(e))
          .toList(),
      from: DateTime.tryParse(dateRangeJson['from'] ?? '') ?? DateTime.now(),
      to: DateTime.tryParse(dateRangeJson['to'] ?? '') ?? DateTime.now(),
    );
  }
}

class CarKPIModel extends CarKPIEntity {
  const CarKPIModel({
    required super.totalCarBookings,
    required super.carRevenue,
    required super.avgRentalDays,
    required super.carPartners,
    super.bookingsDelta,
    super.revenueDelta,
  });

  factory CarKPIModel.fromJson(Map<String, dynamic> json) {
    return CarKPIModel(
      totalCarBookings: json['totalCarBookings'] ?? 0,
      carRevenue: (json['carRevenue'] ?? 0).toDouble(),
      avgRentalDays: (json['avgRentalDays'] ?? 0).toDouble(),
      carPartners: json['carPartners'] ?? 0,
      bookingsDelta: json['bookingsDelta']?.toString(),
      revenueDelta: json['revenueDelta']?.toString(),
    );
  }
}

class CarFiltersModel extends CarFiltersEntity {
  const CarFiltersModel({
    required super.carTypes,
    required super.categories,
  });

  factory CarFiltersModel.fromJson(Map<String, dynamic> json) {
    return CarFiltersModel(
      carTypes: (json['carTypes'] as List?)?.map((e) => e.toString()).toList() ?? [],
      categories: (json['categories'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}

class CarBookingModel extends CarBookingEntity {
  const CarBookingModel({
    required super.id,
    required super.car,
    required super.from,
    required super.to,
    required super.pickupDate,
    required super.returnDate,
    required super.duration,
    required super.price,
    required super.status,
    super.customer,
  });

  factory CarBookingModel.fromJson(Map<String, dynamic> json) {
    return CarBookingModel(
      id: json['id']?.toString() ?? '',
      car: json['car']?.toString() ?? 'Unknown Car',
      from: json['from']?.toString() ?? 'N/A',
      to: json['to']?.toString() ?? 'N/A',
      pickupDate: DateTime.tryParse(json['pickupDate'] ?? '') ?? DateTime.now(),
      returnDate: DateTime.tryParse(json['returnDate'] ?? '') ?? DateTime.now(),
      duration: json['duration']?.toString() ?? 'N/A',
      price: (json['price'] ?? 0).toDouble(),
      status: json['status']?.toString() ?? 'pending',
      customer: json['customer']?.toString(),
    );
  }
}
