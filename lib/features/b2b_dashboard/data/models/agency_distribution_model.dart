import '../../domain/entities/agency_distribution_entity.dart';

class AgencyDistributionModel extends AgencyDistributionEntity {
  const AgencyDistributionModel({
    required super.type,
    required super.value,
  });

  factory AgencyDistributionModel.fromJson(Map<String, dynamic> json) {
    return AgencyDistributionModel(
      type: json['type'] ?? '',
      value: (json['value'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'value': value,
    };
  }
}
