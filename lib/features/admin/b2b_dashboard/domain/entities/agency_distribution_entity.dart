import 'package:equatable/equatable.dart';

class AgencyDistributionEntity extends Equatable {
  final String type;
  final double value;

  const AgencyDistributionEntity({
    required this.type,
    required this.value,
  });

  @override
  List<Object?> get props => [type, value];
}
