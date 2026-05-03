import 'package:travle/features/admin/b2b_dashboard/domain/entities/agency_distribution_entity.dart';

class AgencyDistributionModel extends AgencyDistributionEntity {
  const AgencyDistributionModel({
    required super.type,
    required super.value,
  });

  factory AgencyDistributionModel.fromJson(Map<String, dynamic> json) {
    return AgencyDistributionModel(
      type: json['type'] as String? ?? '',
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'value': value,
    };
  }
}
