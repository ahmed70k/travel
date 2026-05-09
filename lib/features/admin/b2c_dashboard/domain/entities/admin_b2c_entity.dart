import 'package:equatable/equatable.dart';
import 'package:travle/features/admin/b2b_dashboard/domain/entities/date_range_entity.dart';
import 'package:travle/features/admin/b2c_dashboard/domain/entities/b2c_kpis_entity.dart';
import 'package:travle/features/admin/b2c_dashboard/domain/entities/customer_distribution_entity.dart';
import 'package:travle/features/admin/b2c_dashboard/domain/entities/top_customer_entity.dart';

class AdminB2CEntity extends Equatable {
  final B2CKPIsEntity kpis;
  final List<CustomerDistributionEntity> customerDistribution;
  final List<TopCustomerEntity> topCustomers;
  final DateRangeEntity dateRange;

  const AdminB2CEntity({
    required this.kpis,
    required this.customerDistribution,
    required this.topCustomers,
    required this.dateRange,
  });

  @override
  List<Object?> get props => [
        kpis,
        customerDistribution,
        topCustomers,
        dateRange,
      ];
}
