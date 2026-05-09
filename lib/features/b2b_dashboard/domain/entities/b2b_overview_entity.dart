import 'package:equatable/equatable.dart';
import 'b2b_kpis_entity.dart';
import 'agency_distribution_entity.dart';
import 'top_agency_entity.dart';
import 'modules_entity.dart';
import 'date_range_entity.dart';

class B2BOverviewEntity extends Equatable {
  final B2BKPIsEntity kpis;
  final List<AgencyDistributionEntity> distribution;
  final List<TopAgencyEntity> topAgencies;
  final ModulesEntity modules;
  final DateRangeEntity dateRange;

  const B2BOverviewEntity({
    required this.kpis,
    required this.distribution,
    required this.topAgencies,
    required this.modules,
    required this.dateRange,
  });

  @override
  List<Object?> get props => [
        kpis,
        distribution,
        topAgencies,
        modules,
        dateRange,
      ];
}
