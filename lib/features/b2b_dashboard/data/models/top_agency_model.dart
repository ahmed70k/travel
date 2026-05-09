import '../../domain/entities/top_agency_entity.dart';

class TopAgencyModel extends TopAgencyEntity {
  const TopAgencyModel({
    required super.name,
    required super.sales,
  });

  factory TopAgencyModel.fromJson(Map<String, dynamic> json) {
    return TopAgencyModel(
      name: json['name'] ?? '',
      sales: (json['sales'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sales': sales,
    };
  }
}
