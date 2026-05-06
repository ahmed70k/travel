import '../../domain/entities/b2c_overview_entity.dart';

class B2COverviewModel extends B2COverviewEntity {
  const B2COverviewModel({
    required super.kpis,
    required super.customerDistribution,
    required super.growthLast6Months,
    required super.accessibleModules,
    super.from,
    super.to,
  });

  factory B2COverviewModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;

    final kpisJson = data['kpis'] ?? {};
    final distributionJson = data['customerDistribution'] as List? ?? [];
    final growthJson = data['growthLast6Months'] as List? ?? [];
    final modulesJson = data['accessibleModules'] as List? ?? [];
    final dateRangeJson = data['dateRange'] ?? {};

    return B2COverviewModel(
      kpis: B2CKPIModel.fromJson(kpisJson),
      customerDistribution: distributionJson
          .map((e) => CustomerDistributionModel.fromJson(e))
          .toList(),
      growthLast6Months:
          growthJson.map((e) => GrowthModel.fromJson(e)).toList(),
      accessibleModules: modulesJson.map((e) => e.toString()).toList(),
      from: DateTime.tryParse(dateRangeJson['from'] ?? ''),
      to: DateTime.tryParse(dateRangeJson['to'] ?? ''),
    );
  }
}

class B2CKPIModel extends B2CKPIEntity {
  const B2CKPIModel({
    required super.totalCustomers,
    required super.totalValue,
    required super.newThisMonth,
    required super.avgSpend,
  });

  factory B2CKPIModel.fromJson(Map<String, dynamic> json) {
    return B2CKPIModel(
      totalCustomers: json['totalCustomers'] ?? 0,
      totalValue: (json['totalValue'] ?? 0).toDouble(),
      newThisMonth: json['newThisMonth'] ?? 0,
      avgSpend: (json['avgSpend'] ?? 0).toDouble(),
    );
  }
}

class CustomerDistributionModel extends CustomerDistributionEntity {
  const CustomerDistributionModel({
    required super.type,
    required super.value,
  });

  factory CustomerDistributionModel.fromJson(Map<String, dynamic> json) {
    return CustomerDistributionModel(
      type: json['type'] ?? '',
      value: json['value'] ?? 0,
    );
  }
}

class GrowthModel extends GrowthEntity {
  const GrowthModel({
    required super.month,
    required super.value,
  });

  factory GrowthModel.fromJson(Map<String, dynamic> json) {
    return GrowthModel(
      month: json['month'] ?? '',
      value: json['value'] ?? 0,
    );
  }
}
