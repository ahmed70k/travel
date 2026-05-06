import 'package:equatable/equatable.dart';

class MeDashboardKPIEntity extends Equatable {
  final int b2bAgencies;
  final String b2bDelta;
  final int b2cCustomers;
  final String b2cDelta;
  final double totalProfit;
  final String formattedProfit;
  final String profitDelta;
  final int totalBookings;
  final String bookingsDelta;

  const MeDashboardKPIEntity({
    required this.b2bAgencies,
    required this.b2bDelta,
    required this.b2cCustomers,
    required this.b2cDelta,
    required this.totalProfit,
    required this.formattedProfit,
    required this.profitDelta,
    required this.totalBookings,
    required this.bookingsDelta,
  });

  @override
  List<Object?> get props => [
        b2bAgencies,
        b2bDelta,
        b2cCustomers,
        b2cDelta,
        totalProfit,
        formattedProfit,
        profitDelta,
        totalBookings,
        bookingsDelta,
      ];
}

class MeDashboardEntity extends Equatable {
  final String role;
  final MeDashboardKPIEntity kpis;
  final DateTime? from;
  final DateTime? to;

  const MeDashboardEntity({
    required this.role,
    required this.kpis,
    this.from,
    this.to,
  });

  @override
  List<Object?> get props => [role, kpis, from, to];
}
