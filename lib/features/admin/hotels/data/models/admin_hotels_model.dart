import '../../domain/entities/admin_hotels_entity.dart';

class AdminHotelsModel extends AdminHotelsEntity {
  const AdminHotelsModel({
    required super.kpis,
    required super.filters,
    required super.bookings,
    required super.from,
    required super.to,
  });

  factory AdminHotelsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    final kpisJson = data['kpis'] ?? {};
    final filtersJson = data['filters'] ?? {};
    final bookingsJson = (data['bookings'] as List?) ?? [];
    final dateRangeJson = data['dateRange'] ?? {};

    return AdminHotelsModel(
      kpis: HotelKPIModel.fromJson(kpisJson),
      filters: HotelFiltersModel.fromJson(filtersJson),
      bookings: bookingsJson
          .map((e) => HotelBookingModel.fromJson(e))
          .toList(),
      from: DateTime.tryParse(dateRangeJson['from'] ?? '') ?? DateTime.now(),
      to: DateTime.tryParse(dateRangeJson['to'] ?? '') ?? DateTime.now(),
    );
  }
}

class HotelKPIModel extends HotelKPIEntity {
  const HotelKPIModel({
    required super.totalHotelBookings,
    required super.hotelRevenue,
    required super.avgOccupancy,
    required super.hotelPartners,
    super.bookingsDelta,
    super.revenueDelta,
  });

  factory HotelKPIModel.fromJson(Map<String, dynamic> json) {
    return HotelKPIModel(
      totalHotelBookings: json['totalHotelBookings'] ?? 0,
      hotelRevenue: (json['hotelRevenue'] ?? 0).toDouble(),
      avgOccupancy: (json['avgOccupancy'] ?? 0).toDouble(),
      hotelPartners: json['hotelPartners'] ?? 0,
      bookingsDelta: json['bookingsDelta']?.toString(),
      revenueDelta: json['revenueDelta']?.toString(),
    );
  }
}

class HotelFiltersModel extends HotelFiltersEntity {
  const HotelFiltersModel({
    required super.guestsCount,
    required super.categories,
  });

  factory HotelFiltersModel.fromJson(Map<String, dynamic> json) {
    return HotelFiltersModel(
      guestsCount: (json['guestsCount'] as List?)?.map((e) => e.toString()).toList() ?? [],
      categories: (json['categories'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}

class HotelBookingModel extends HotelBookingEntity {
  const HotelBookingModel({
    required super.id,
    required super.hotel,
    required super.city,
    required super.checkIn,
    required super.checkOut,
    required super.guests,
    required super.price,
    required super.status,
    super.updatedAt,
    required super.customer,
  });

  factory HotelBookingModel.fromJson(Map<String, dynamic> json) {
    return HotelBookingModel(
      id: json['id']?.toString() ?? '',
      hotel: json['hotel']?.toString() ?? 'Unknown Hotel',
      city: json['city']?.toString() ?? 'N/A',
      checkIn: DateTime.tryParse(json['checkIn'] ?? '') ?? DateTime.now(),
      checkOut: DateTime.tryParse(json['checkOut'] ?? '') ?? DateTime.now(),
      guests: json['guests']?.toString() ?? 'N/A',
      price: (json['price'] ?? 0).toDouble(),
      status: json['status']?.toString() ?? 'pending',
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? ''),
      customer: json['customer']?.toString() ?? 'N/A',
    );
  }
}
