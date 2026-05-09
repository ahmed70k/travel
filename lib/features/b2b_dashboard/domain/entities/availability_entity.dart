import 'package:equatable/equatable.dart';

class AvailabilityEntity extends Equatable {
  final int booked;
  final int capacity;
  final int available;
  final bool hasAvailability;

  const AvailabilityEntity({
    required this.booked,
    required this.capacity,
    required this.available,
    required this.hasAvailability,
  });

  double get progress => capacity > 0 ? booked / capacity : 0.0;

  @override
  List<Object?> get props => [booked, capacity, available, hasAvailability];
}
