import 'package:equatable/equatable.dart';

class CustomerDistributionEntity extends Equatable {
  final String label;
  final int count;
  final double percentage;

  const CustomerDistributionEntity({
    required this.label,
    required this.count,
    required this.percentage,
  });

  @override
  List<Object?> get props => [label, count, percentage];
}
