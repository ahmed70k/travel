import 'package:equatable/equatable.dart';

class TopCustomerEntity extends Equatable {
  final String id;
  final String name;
  final double totalSpent;
  final int totalBookings;

  const TopCustomerEntity({
    required this.id,
    required this.name,
    required this.totalSpent,
    required this.totalBookings,
  });

  @override
  List<Object?> get props => [id, name, totalSpent, totalBookings];
}
