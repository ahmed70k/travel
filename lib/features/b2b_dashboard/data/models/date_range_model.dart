import '../../domain/entities/date_range_entity.dart';

class DateRangeModel extends DateRangeEntity {
  const DateRangeModel({
    required super.from,
    required super.to,
  });

  factory DateRangeModel.fromJson(Map<String, dynamic> json) {
    return DateRangeModel(
      from: DateTime.parse(json['from'] ?? DateTime.now().toIso8601String()),
      to: DateTime.parse(json['to'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'from': from.toIso8601String(),
      'to': to.toIso8601String(),
    };
  }
}
