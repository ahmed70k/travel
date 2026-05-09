import 'package:travle/features/admin/b2c_dashboard/domain/entities/b2c_kpis_entity.dart';

class B2CKPIsModel extends B2CKPIsEntity {
  const B2CKPIsModel({
    required super.totalCustomers,
    required super.activeCustomers,
    required super.totalRevenue,
    required super.totalBookings,
  });

  factory B2CKPIsModel.fromJson(Map<String, dynamic> json) {
    return B2CKPIsModel(
      totalCustomers: json['totalCustomers'] ?? 0,
      activeCustomers: json['activeCustomers'] ?? 0,
      totalRevenue: (json['totalRevenue'] ?? 0).toDouble(),
      totalBookings: (json['totalBookings'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalCustomers': totalCustomers,
      'activeCustomers': activeCustomers,
      'totalRevenue': totalRevenue,
      'totalBookings': totalBookings,
    };
  }
}
