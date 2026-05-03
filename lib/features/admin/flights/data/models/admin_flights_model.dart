import '../../domain/entities/admin_flights_entity.dart';

class AdminFlightsModel extends AdminFlightsEntity {
  const AdminFlightsModel({
    required super.kpis,
    required super.filters,
    required super.bookings,
    required super.from,
    required super.to,
  });

  factory AdminFlightsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    final kpisJson = data['kpis'] ?? {};
    final filtersJson = data['filters'] ?? {};
    final bookingsJson = (data['bookings'] as List?) ?? [];
    final dateRangeJson = data['dateRange'] ?? {};

    return AdminFlightsModel(
      kpis: FlightKPIModel.fromJson(kpisJson),
      filters: FlightFiltersModel.fromJson(filtersJson),
      bookings: bookingsJson
          .map((e) => FlightBookingModel.fromJson(e))
          .toList(),
      from: DateTime.tryParse(dateRangeJson['from'] ?? '') ?? DateTime.now(),
      to: DateTime.tryParse(dateRangeJson['to'] ?? '') ?? DateTime.now(),
    );
  }
}

class FlightKPIModel extends FlightKPIEntity {
  const FlightKPIModel({
    required super.totalFlightBookings,
    required super.flightRevenue,
    required super.occupancyRate,
    required super.partnerAirlines,
    super.bookingsDelta,
    super.revenueDelta,
  });

  factory FlightKPIModel.fromJson(Map<String, dynamic> json) {
    return FlightKPIModel(
      totalFlightBookings: json['totalFlightBookings'] ?? 0,
      flightRevenue: (json['flightRevenue'] ?? 0).toDouble(),
      occupancyRate: (json['occupancyRate'] ?? 0).toDouble(),
      partnerAirlines: json['partnerAirlines'] ?? 0,
      bookingsDelta: json['bookingsDelta']?.toString(),
      revenueDelta: json['revenueDelta']?.toString(),
    );
  }
}

class FlightFiltersModel extends FlightFiltersEntity {
  const FlightFiltersModel({
    required super.tripType,
    required super.categories,
  });

  factory FlightFiltersModel.fromJson(Map<String, dynamic> json) {
    return FlightFiltersModel(
      tripType: (json['tripType'] as List?)?.map((e) => e.toString()).toList() ?? [],
      categories: (json['categories'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}

class FlightBookingModel extends FlightBookingEntity {
  const FlightBookingModel({
    required super.id,
    super.airline,
    super.flightNo,
    super.from,
    super.to,
    super.departureTime,
    super.arrivalTime,
    super.duration,
    required super.customer,
    required super.price,
    required super.status,
    super.updatedAt,
  });

  factory FlightBookingModel.fromJson(Map<String, dynamic> json) {
    return FlightBookingModel(
      id: json['id']?.toString() ?? '',
      airline: json['airline'],
      flightNo: json['flightNo'],
      from: json['from'],
      to: json['to'],
      departureTime: DateTime.tryParse(json['departureTime'] ?? ''),
      arrivalTime: DateTime.tryParse(json['arrivalTime'] ?? ''),
      duration: json['duration'],
      customer: json['customer']?.toString() ?? 'N/A',
      price: (json['price'] ?? 0).toDouble(),
      status: json['status']?.toString() ?? 'pending',
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? ''),
    );
  }
}
