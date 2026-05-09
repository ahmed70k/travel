import 'package:equatable/equatable.dart';

class CurrentDashboardEntity extends Equatable {
  final String role;
  final B2cDashboardDataEntity dashboard;

  const CurrentDashboardEntity({
    required this.role,
    required this.dashboard,
  });

  @override
  List<Object?> get props => [role, dashboard];
}

class B2cDashboardDataEntity extends Equatable {
  final KpisEntity kpis;
  final List<CustomerDistributionEntity> customerDistribution;
  final List<GrowthLast6MonthsEntity> growthLast6Months;
  final List<String> accessibleModules;
  final DateRangeEntity dateRange;

  const B2cDashboardDataEntity({
    required this.kpis,
    this.customerDistribution = const [],
    this.growthLast6Months = const [],
    required this.accessibleModules,
    required this.dateRange,
  });

  @override
  List<Object?> get props => [
        kpis,
        customerDistribution,
        growthLast6Months,
        accessibleModules,
        dateRange,
      ];
}

class KpisEntity extends Equatable {
  final int totalCustomers;
  final double totalValue;
  final int newThisMonth;
  final double avgSpend;

  const KpisEntity({
    required this.totalCustomers,
    required this.totalValue,
    required this.newThisMonth,
    required this.avgSpend,
  });

  @override
  List<Object?> get props => [totalCustomers, totalValue, newThisMonth, avgSpend];
}

class CustomerDistributionEntity extends Equatable {
  final String type;
  final int value;

  const CustomerDistributionEntity({
    required this.type,
    required this.value,
  });

  @override
  List<Object?> get props => [type, value];
}

class GrowthLast6MonthsEntity extends Equatable {
  final String month;
  final int value;

  const GrowthLast6MonthsEntity({
    required this.month,
    required this.value,
  });

  @override
  List<Object?> get props => [month, value];
}

class DateRangeEntity extends Equatable {
  final DateTime? from;
  final DateTime? to;

  const DateRangeEntity({
    this.from,
    this.to,
  });

  @override
  List<Object?> get props => [from, to];
}
