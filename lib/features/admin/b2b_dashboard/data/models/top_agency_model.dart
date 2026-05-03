import 'package:travle/features/admin/b2b_dashboard/domain/entities/top_agency_entity.dart';

class TopAgencyModel extends TopAgencyEntity {
  const TopAgencyModel({
    required super.name,
    required super.sales,
  });

  factory TopAgencyModel.fromJson(Map<String, dynamic> json) {
    return TopAgencyModel(
      name: json['name'] as String? ?? '',
      sales: json['sales'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sales': sales,
    };
  }
}
