import 'package:equatable/equatable.dart';

class B2BKPIsEntity extends Equatable {
  final int totalAgencies;
  final double totalRevenue;
  final double totalCommission;
  final double avgCommissionRate;

  const B2BKPIsEntity({
    required this.totalAgencies,
    required this.totalRevenue,
    required this.totalCommission,
    required this.avgCommissionRate,
  });

  @override
  List<Object?> get props => [
        totalAgencies,
        totalRevenue,
        totalCommission,
        avgCommissionRate,
      ];
}
