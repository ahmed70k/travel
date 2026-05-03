import 'package:equatable/equatable.dart';
import '../../domain/entities/admin_cars_entity.dart';

abstract class AdminCarsState extends Equatable {
  const AdminCarsState();

  @override
  List<Object?> get props => [];
}

class AdminCarsInitial extends AdminCarsState {}

class AdminCarsLoading extends AdminCarsState {}

class AdminCarsLoaded extends AdminCarsState {
  final AdminCarsEntity data;

  const AdminCarsLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class AdminCarsError extends AdminCarsState {
  final String message;

  const AdminCarsError(this.message);

  @override
  List<Object?> get props => [message];
}
