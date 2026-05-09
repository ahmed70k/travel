import 'package:equatable/equatable.dart';

class TopAgencyEntity extends Equatable {
  final String name;
  final double sales;

  const TopAgencyEntity({
    required this.name,
    required this.sales,
  });

  @override
  List<Object?> get props => [name, sales];
}
