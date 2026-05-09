import 'package:travle/features/admin/b2c_dashboard/domain/entities/top_customer_entity.dart';

class TopCustomerModel extends TopCustomerEntity {
  const TopCustomerModel({
    required super.id,
    required super.name,
    required super.totalSpent,
    required super.totalBookings,
  });

  factory TopCustomerModel.fromJson(Map<String, dynamic> json) {
    return TopCustomerModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      totalSpent: (json['totalSpent'] ?? 0).toDouble(),
      totalBookings: json['totalBookings'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'totalSpent': totalSpent,
      'totalBookings': totalBookings,
    };
  }
}
