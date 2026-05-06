import 'package:equatable/equatable.dart';

class B2COverviewEntity extends Equatable {
  final B2CKPIEntity kpis;
  final List<CustomerDistributionEntity> customerDistribution;
  final List<GrowthEntity> growthLast6Months;
  final List<String> accessibleModules;
  final DateTime? from;
  final DateTime? to;

  const B2COverviewEntity({
    required this.kpis,
    required this.customerDistribution,
    required this.growthLast6Months,
    required this.accessibleModules,
    this.from,
    this.to,
  });

  @override
  List<Object?> get props => [
        kpis,
        customerDistribution,
        growthLast6Months,
        accessibleModules,
        from,
        to,
      ];
}

class B2CKPIEntity extends Equatable {
  final int totalCustomers;
  final double totalValue;
  final int newThisMonth;
  final double avgSpend;

  const B2CKPIEntity({
    required this.totalCustomers,
    required this.totalValue,
    required this.newThisMonth,
    required this.avgSpend,
  });

  @override
  List<Object?> get props => [
        totalCustomers,
        totalValue,
        newThisMonth,
        avgSpend,
      ];
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

class GrowthEntity extends Equatable {
  final String month;
  final int value;

  const GrowthEntity({
    required this.month,
    required this.value,
  });

  @override
  List<Object?> get props => [month, value];
}
