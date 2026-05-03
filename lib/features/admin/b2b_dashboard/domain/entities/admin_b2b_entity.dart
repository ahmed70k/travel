import 'package:equatable/equatable.dart';
import 'package:travle/features/admin/b2b_dashboard/domain/entities/agency_distribution_entity.dart';
import 'package:travle/features/admin/b2b_dashboard/domain/entities/b2b_kpis_entity.dart';
import 'package:travle/features/admin/b2b_dashboard/domain/entities/date_range_entity.dart';
import 'package:travle/features/admin/b2b_dashboard/domain/entities/top_agency_entity.dart';

class AdminB2BEntity extends Equatable {
  final B2BKPIsEntity kpis;
  final List<AgencyDistributionEntity> agencyDistribution;
  final List<TopAgencyEntity> topAgencies;
  final DateRangeEntity dateRange;

  const AdminB2BEntity({
    required this.kpis,
    required this.agencyDistribution,
    required this.topAgencies,
    required this.dateRange,
  });

  @override
  List<Object?> get props => [
        kpis,
        agencyDistribution,
        topAgencies,
        dateRange,
      ];
}
