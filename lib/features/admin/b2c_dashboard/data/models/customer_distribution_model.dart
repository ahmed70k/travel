import 'package:travle/features/admin/b2c_dashboard/domain/entities/customer_distribution_entity.dart';

class CustomerDistributionModel extends CustomerDistributionEntity {
  const CustomerDistributionModel({
    required super.label,
    required super.count,
    required super.percentage,
  });

  factory CustomerDistributionModel.fromJson(Map<String, dynamic> json) {
    return CustomerDistributionModel(
      label: json['label'] ?? '',
      count: json['count'] ?? 0,
      percentage: (json['percentage'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'count': count,
      'percentage': percentage,
    };
  }
}
