import 'package:travle/features/admin/b2b_dashboard/data/models/agency_distribution_model.dart';
import 'package:travle/features/admin/b2b_dashboard/data/models/b2b_kpis_model.dart';
import 'package:travle/features/admin/b2b_dashboard/data/models/date_range_model.dart';
import 'package:travle/features/admin/b2b_dashboard/data/models/top_agency_model.dart';
import 'package:travle/features/admin/b2b_dashboard/domain/entities/admin_b2b_entity.dart';

class AdminB2BModel extends AdminB2BEntity {
  const AdminB2BModel({
    required super.kpis,
    required super.agencyDistribution,
    required super.topAgencies,
    required super.dateRange,
  });

  factory AdminB2BModel.fromJson(Map<String, dynamic> json) {
    return AdminB2BModel(
      kpis: json['kpis'] != null
          ? B2BKPIsModel.fromJson(json['kpis'] as Map<String, dynamic>)
          : const B2BKPIsModel(
              totalAgencies: 0,
              totalRevenue: 0,
              totalCommission: 0,
              avgCommissionRate: 0,
            ),
      agencyDistribution: (json['agencyDistribution'] as List<dynamic>?)
              ?.map((e) =>
                  AgencyDistributionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      topAgencies: (json['topAgencies'] as List<dynamic>?)
              ?.map((e) => TopAgencyModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      dateRange: json['dateRange'] != null
          ? DateRangeModel.fromJson(json['dateRange'] as Map<String, dynamic>)
          : DateRangeModel(from: DateTime.now(), to: DateTime.now()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kpis': (kpis as B2BKPIsModel).toJson(),
      'agencyDistribution': (agencyDistribution as List<AgencyDistributionModel>)
          .map((e) => e.toJson())
          .toList(),
      'topAgencies':
          (topAgencies as List<TopAgencyModel>).map((e) => e.toJson()).toList(),
      'dateRange': (dateRange as DateRangeModel).toJson(),
    };
  }
}
