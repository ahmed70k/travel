import 'package:travle/features/admin/b2b_dashboard/domain/entities/b2b_kpis_entity.dart';

class B2BKPIsModel extends B2BKPIsEntity {
  const B2BKPIsModel({
    required super.totalAgencies,
    required super.totalRevenue,
    required super.totalCommission,
    required super.avgCommissionRate,
  });

  factory B2BKPIsModel.fromJson(Map<String, dynamic> json) {
    return B2BKPIsModel(
      totalAgencies: json['totalAgencies'] as int? ?? 0,
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0.0,
      totalCommission: (json['totalCommission'] as num?)?.toDouble() ?? 0.0,
      avgCommissionRate: (json['avgCommissionRate'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalAgencies': totalAgencies,
      'totalRevenue': totalRevenue,
      'totalCommission': totalCommission,
      'avgCommissionRate': avgCommissionRate,
    };
  }
}
