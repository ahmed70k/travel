import '../../domain/entities/current_dashboard_entity.dart';

class DashboardMeResponseModel {
  final bool success;
  final String message;
  final DashboardMeDataModel data;

  DashboardMeResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory DashboardMeResponseModel.fromJson(Map<String, dynamic> json) {
    return DashboardMeResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: DashboardMeDataModel.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class DashboardMeDataModel extends CurrentDashboardEntity {
  const DashboardMeDataModel({
    required super.role,
    required super.dashboard,
  });

  factory DashboardMeDataModel.fromJson(Map<String, dynamic> json) {
    return DashboardMeDataModel(
      role: json['role'] ?? '',
      dashboard: B2cDashboardDataModel.fromJson(json['dashboard'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'dashboard': (dashboard as B2cDashboardDataModel).toJson(),
    };
  }
}

class B2cDashboardDataModel extends B2cDashboardDataEntity {
  const B2cDashboardDataModel({
    required super.kpis,
    super.customerDistribution,
    super.growthLast6Months,
    required super.accessibleModules,
    required super.dateRange,
  });

  factory B2cDashboardDataModel.fromJson(Map<String, dynamic> json) {
    return B2cDashboardDataModel(
      kpis: KpisModel.fromJson(json['kpis'] ?? {}),
      customerDistribution: (json['customerDistribution'] as List? ?? [])
          .map((i) => CustomerDistributionModel.fromJson(i))
          .toList(),
      growthLast6Months: (json['growthLast6Months'] as List? ?? [])
          .map((i) => GrowthLast6MonthsModel.fromJson(i))
          .toList(),
      accessibleModules: List<String>.from(json['accessibleModules'] ?? []),
      dateRange: DateRangeModel.fromJson(json['dateRange'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kpis': (kpis as KpisModel).toJson(),
      'customerDistribution': customerDistribution.map((i) => (i as CustomerDistributionModel).toJson()).toList(),
      'growthLast6Months': growthLast6Months.map((i) => (i as GrowthLast6MonthsModel).toJson()).toList(),
      'accessibleModules': accessibleModules,
      'dateRange': (dateRange as DateRangeModel).toJson(),
    };
  }
}

class KpisModel extends KpisEntity {
  const KpisModel({
    required super.totalCustomers,
    required super.totalValue,
    required super.newThisMonth,
    required super.avgSpend,
  });

  factory KpisModel.fromJson(Map<String, dynamic> json) {
    return KpisModel(
      totalCustomers: json['totalCustomers'] ?? 0,
      totalValue: (json['totalValue'] ?? 0).toDouble(),
      newThisMonth: json['newThisMonth'] ?? 0,
      avgSpend: (json['avgSpend'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalCustomers': totalCustomers,
      'totalValue': totalValue,
      'newThisMonth': newThisMonth,
      'avgSpend': avgSpend,
    };
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

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'value': value,
    };
  }
}

class GrowthLast6MonthsModel extends GrowthLast6MonthsEntity {
  const GrowthLast6MonthsModel({
    required super.month,
    required super.value,
  });

  factory GrowthLast6MonthsModel.fromJson(Map<String, dynamic> json) {
    return GrowthLast6MonthsModel(
      month: json['month'] ?? '',
      value: json['value'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'value': value,
    };
  }
}

class DateRangeModel extends DateRangeEntity {
  const DateRangeModel({
    super.from,
    super.to,
  });

  factory DateRangeModel.fromJson(Map<String, dynamic> json) {
    return DateRangeModel(
      from: json['from'] != null ? DateTime.parse(json['from']) : null,
      to: json['to'] != null ? DateTime.parse(json['to']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'from': from?.toIso8601String(),
      'to': to?.toIso8601String(),
    };
  }
}
