import 'package:equatable/equatable.dart';

class B2CKPIsEntity extends Equatable {
  final int totalCustomers;
  final int activeCustomers;
  final double totalRevenue;
  final double totalBookings;

  const B2CKPIsEntity({
    required this.totalCustomers,
    required this.activeCustomers,
    required this.totalRevenue,
    required this.totalBookings,
  });

  @override
  List<Object?> get props => [
        totalCustomers,
        activeCustomers,
        totalRevenue,
        totalBookings,
      ];
}
