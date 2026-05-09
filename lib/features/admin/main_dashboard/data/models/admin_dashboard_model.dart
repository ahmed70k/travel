import '../../domain/entities/admin_dashboard_entity.dart';

class AdminDashboardModel extends AdminDashboardEntity {
  const AdminDashboardModel({
    required super.role,
    required super.kpis,
    required super.dateRange,
  });

  factory AdminDashboardModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    final dashboardData = data['dashboard'] ?? data;
    
    return AdminDashboardModel(
      role: data['role'] ?? '',
      kpis: AdminKPIsModel.fromJson(dashboardData['kpis'] ?? {}),
      dateRange: AdminDateRangeModel.fromJson(dashboardData['dateRange'] ?? {}),
    );
  }
}

class AdminKPIsModel extends AdminKPIsEntity {
  const AdminKPIsModel({
    required super.b2bAgencies,
    required super.b2cCustomers,
    required super.totalProfit,
    required super.totalBookings,
  });

  factory AdminKPIsModel.fromJson(Map<String, dynamic> json) {
    // Mapping for both Admin and B2B formats to be safe
    return AdminKPIsModel(
      b2bAgencies: KPIValueModel.fromJson(json['b2bAgencies'] ?? json['totalAgencies'] ?? {}),
      b2cCustomers: KPIValueModel.fromJson(json['b2cCustomers'] ?? json['totalCustomers'] ?? {}),
      totalProfit: KPIValueModel.fromJson(json['totalProfit'] ?? json['totalRevenue'] ?? {}),
      totalBookings: KPIValueModel.fromJson(json['totalBookings'] ?? json['totalCommission'] ?? {}),
    );
  }
}

class KPIValueModel extends KPIValueEntity {
  const KPIValueModel({
    required super.total,
    required super.delta,
    super.formatted,
  });

  factory KPIValueModel.fromJson(Map<String, dynamic> json) {
    return KPIValueModel(
      total: (json['total'] ?? 0.0).toDouble(),
      delta: json['delta']?.toString() ?? '0%',
      formatted: json['formatted'],
    );
  }
}

class AdminDateRangeModel extends AdminDateRangeEntity {
  const AdminDateRangeModel({
    super.from,
    super.to,
  });

  factory AdminDateRangeModel.fromJson(Map<String, dynamic> json) {
    return AdminDateRangeModel(
      from: json['from'] != null ? DateTime.tryParse(json['from']) : null,
      to: json['to'] != null ? DateTime.tryParse(json['to']) : null,
    );
  }
}
