import '../../domain/entities/me_dashboard_entity.dart';

class MeDashboardModel extends MeDashboardEntity {
  const MeDashboardModel({
    required super.role,
    required super.kpis,
    super.from,
    super.to,
  });

  factory MeDashboardModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    final role = data['role'] ?? '';
    final dashboard = data['dashboard'] ?? {};
    final kpisJson = dashboard['kpis'] ?? {};
    final dateRangeJson = dashboard['dateRange'] ?? {};

    return MeDashboardModel(
      role: role,
      kpis: MeDashboardKPIModel.fromJson(kpisJson),
      from: DateTime.tryParse(dateRangeJson['from'] ?? ''),
      to: DateTime.tryParse(dateRangeJson['to'] ?? ''),
    );
  }
}

class MeDashboardKPIModel extends MeDashboardKPIEntity {
  const MeDashboardKPIModel({
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

  factory MeDashboardKPIModel.fromJson(Map<String, dynamic> json) {
    final b2b = json['b2bAgencies'] ?? {};
    final b2c = json['b2cCustomers'] ?? {};
    final profit = json['totalProfit'] ?? {};
    final bookings = json['totalBookings'] ?? {};

    return MeDashboardKPIModel(
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
