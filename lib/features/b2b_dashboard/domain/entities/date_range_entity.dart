import 'package:equatable/equatable.dart';

class DateRangeEntity extends Equatable {
  final DateTime from;
  final DateTime to;

  const DateRangeEntity({
    required this.from,
    required this.to,
  });

  @override
  List<Object?> get props => [from, to];
}
