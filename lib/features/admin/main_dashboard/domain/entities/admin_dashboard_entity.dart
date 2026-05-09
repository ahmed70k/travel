import 'package:equatable/equatable.dart';

class AdminDashboardEntity extends Equatable {
  final String role;
  final AdminKPIsEntity kpis;
  final AdminDateRangeEntity dateRange;

  const AdminDashboardEntity({
    required this.role,
    required this.kpis,
    required this.dateRange,
  });

  @override
  List<Object?> get props => [role, kpis, dateRange];
}

class AdminKPIsEntity extends Equatable {
  final KPIValueEntity b2bAgencies;
  final KPIValueEntity b2cCustomers;
  final KPIValueEntity totalProfit;
  final KPIValueEntity totalBookings;

  const AdminKPIsEntity({
    required this.b2bAgencies,
    required this.b2cCustomers,
    required this.totalProfit,
    required this.totalBookings,
  });

  @override
  List<Object?> get props => [b2bAgencies, b2cCustomers, totalProfit, totalBookings];
}

class KPIValueEntity extends Equatable {
  final double total;
  final String delta;
  final String? formatted;

  const KPIValueEntity({
    required this.total,
    required this.delta,
    this.formatted,
  });

  @override
  List<Object?> get props => [total, delta, formatted];
}

class AdminDateRangeEntity extends Equatable {
  final DateTime? from;
  final DateTime? to;

  const AdminDateRangeEntity({
    this.from,
    this.to,
  });

  @override
  List<Object?> get props => [from, to];
}
