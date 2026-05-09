import '../../domain/entities/b2b_kpis_entity.dart';

class B2BKPIsModel extends B2BKPIsEntity {
  const B2BKPIsModel({
    required super.totalAgencies,
    required super.totalRevenue,
    required super.totalCommission,
    required super.avgCommissionRate,
  });

  factory B2BKPIsModel.fromJson(Map<String, dynamic> json) {
    return B2BKPIsModel(
      totalAgencies: json['totalAgencies'] ?? 0,
      totalRevenue: (json['totalRevenue'] ?? 0.0).toDouble(),
      totalCommission: (json['totalCommission'] ?? 0.0).toDouble(),
      avgCommissionRate: (json['avgCommissionRate'] ?? 0.0).toDouble(),
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
