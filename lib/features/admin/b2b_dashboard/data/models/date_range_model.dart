import 'package:travle/features/admin/b2b_dashboard/domain/entities/date_range_entity.dart';

class DateRangeModel extends DateRangeEntity {
  const DateRangeModel({
    required super.from,
    required super.to,
  });

  factory DateRangeModel.fromJson(Map<String, dynamic> json) {
    return DateRangeModel(
      from: json['from'] != null
          ? DateTime.tryParse(json['from'] as String) ?? DateTime.now()
          : DateTime.now(),
      to: json['to'] != null
          ? DateTime.tryParse(json['to'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'from': from.toIso8601String(),
      'to': to.toIso8601String(),
    };
  }
}
