import 'package:travle/features/admin/b2b_dashboard/data/models/date_range_model.dart';
import 'package:travle/features/admin/b2c_dashboard/data/models/b2c_kpis_model.dart';
import 'package:travle/features/admin/b2c_dashboard/data/models/customer_distribution_model.dart';
import 'package:travle/features/admin/b2c_dashboard/data/models/top_customer_model.dart';
import 'package:travle/features/admin/b2c_dashboard/domain/entities/admin_b2c_entity.dart';

class AdminB2CModel extends AdminB2CEntity {
  const AdminB2CModel({
    required super.kpis,
    required super.customerDistribution,
    required super.topCustomers,
    required super.dateRange,
  });

  factory AdminB2CModel.fromJson(Map<String, dynamic> json) {
    return AdminB2CModel(
      kpis: json['kpis'] != null
          ? B2CKPIsModel.fromJson(json['kpis'] as Map<String, dynamic>)
          : const B2CKPIsModel(
              totalCustomers: 0,
              activeCustomers: 0,
              totalRevenue: 0,
              totalBookings: 0,
            ),
      customerDistribution: (json['customerDistribution'] as List<dynamic>?)
              ?.map((e) =>
                  CustomerDistributionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      topCustomers: (json['topCustomers'] as List<dynamic>?)
              ?.map((e) => TopCustomerModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      dateRange: json['dateRange'] != null
          ? DateRangeModel.fromJson(json['dateRange'] as Map<String, dynamic>)
          : DateRangeModel(from: DateTime.now(), to: DateTime.now()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kpis': (kpis as B2CKPIsModel).toJson(),
      'customerDistribution': (customerDistribution as List<CustomerDistributionModel>)
          .map((e) => e.toJson())
          .toList(),
      'topCustomers':
          (topCustomers as List<TopCustomerModel>).map((e) => e.toJson()).toList(),
      'dateRange': (dateRange as DateRangeModel).toJson(),
    };
  }
}
