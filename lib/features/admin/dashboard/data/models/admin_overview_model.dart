import '../../domain/entities/admin_overview_entity.dart';

class AdminOverviewModel extends AdminOverviewEntity {
  const AdminOverviewModel({
    required super.greeting,
    required super.kpis,
    required super.bookings,
    required super.quickActions,
    required super.from,
    required super.to,
  });

  factory AdminOverviewModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    final greetingJson = data['greeting'] ?? {};
    final kpisJson = data['kpis'] ?? {};
    final bookingsJson = (data['recentFlightBookings'] as List?) ?? (data['bookings'] as List?) ?? [];
    final quickActionsJson =
        (data['quickActions'] as List?)?.map((e) => e.toString()).toList() ??
        [];
    final dateRangeJson = data['dateRange'] ?? {};

    return AdminOverviewModel(
      greeting: GreetingModel.fromJson(greetingJson),
      kpis: KPIModel.fromJson(kpisJson),
      bookings: bookingsJson.map((e) => BookingModel.fromJson(e)).toList(),
      quickActions: quickActionsJson,
      from: DateTime.tryParse(dateRangeJson['from'] ?? '') ?? DateTime.now(),
      to: DateTime.tryParse(dateRangeJson['to'] ?? '') ?? DateTime.now(),
    );
  }
}

class GreetingModel extends GreetingEntity {
  const GreetingModel({required super.title, required super.subtitle});

  factory GreetingModel.fromJson(Map<String, dynamic> json) {
    return GreetingModel(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
    );
  }
}

class KPIModel extends KPIEntity {
  const KPIModel({
    required super.b2bAgencies,
    required super.b2bDelta,
    required super.b2cCustomers,
    required super.b2cDelta,
    required super.totalProfit,
    required super.formattedProfit,
    required super.profitDelta,
    required super.totalBookings,
    required super.bookingsDelta,
  });

  factory KPIModel.fromJson(Map<String, dynamic> json) {
    final b2b = json['b2bAgencies'] ?? {};
    final b2c = json['b2cCustomers'] ?? {};
    final profit = json['totalProfit'] ?? {};
    final bookings = json['totalBookings'] ?? {};

    return KPIModel(
      b2bAgencies: b2b['total'] ?? 0,
      b2bDelta: (b2b['delta'] ?? '').toString(),
      b2cCustomers: b2c['total'] ?? 0,
      b2cDelta: (b2c['delta'] ?? '').toString(),
      totalProfit: (profit['total'] ?? 0).toDouble(),
      formattedProfit: profit['formatted'] ?? '',
      profitDelta: (profit['delta'] ?? '').toString(),
      totalBookings: bookings['total'] ?? 0,
      bookingsDelta: (bookings['delta'] ?? '').toString(),
    );
  }
}

class BookingModel extends BookingEntity {
  const BookingModel({
    required super.id,
    required super.customer,
    required super.route,
    required super.date,
    required super.price,
    required super.status,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id']?.toString() ?? '',
      customer: json['customer'] ?? '',
      route: json['route'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      price: (json['price'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
    );
  }
}
