import '../../domain/entities/b2b_overview_entity.dart';
import 'b2b_kpis_model.dart';
import 'agency_distribution_model.dart';
import 'top_agency_model.dart';
import 'modules_model.dart';
import 'date_range_model.dart';

class B2BOverviewModel extends B2BOverviewEntity {
  const B2BOverviewModel({
    required super.kpis,
    required super.distribution,
    required super.topAgencies,
    required super.modules,
    required super.dateRange,
  });

  factory B2BOverviewModel.fromJson(Map<String, dynamic> json) {
    return B2BOverviewModel(
      kpis: B2BKPIsModel.fromJson(json['kpis'] ?? {}),
      distribution: (json['distribution'] as List?)
              ?.map((e) => AgencyDistributionModel.fromJson(e))
              .toList() ??
          [],
      topAgencies: (json['topAgencies'] as List?)
              ?.map((e) => TopAgencyModel.fromJson(e))
              .toList() ??
          [],
      modules: ModulesModel.fromJson(json['modules'] ?? {}),
      dateRange: DateRangeModel.fromJson(json['dateRange'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kpis': (kpis as B2BKPIsModel).toJson(),
      'distribution':
          distribution.map((e) => (e as AgencyDistributionModel).toJson()).toList(),
      'topAgencies':
          topAgencies.map((e) => (e as TopAgencyModel).toJson()).toList(),
      'modules': (modules as ModulesModel).toJson(),
      'dateRange': (dateRange as DateRangeModel).toJson(),
    };
  }
}
