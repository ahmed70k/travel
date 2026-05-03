import 'package:equatable/equatable.dart';
import '../../domain/entities/admin_hotels_entity.dart';

abstract class AdminHotelsState extends Equatable {
  const AdminHotelsState();

  @override
  List<Object?> get props => [];
}

class AdminHotelsInitial extends AdminHotelsState {}

class AdminHotelsLoading extends AdminHotelsState {}

class AdminHotelsLoaded extends AdminHotelsState {
  final AdminHotelsEntity data;

  const AdminHotelsLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class AdminHotelsError extends AdminHotelsState {
  final String message;

  const AdminHotelsError(this.message);

  @override
  List<Object?> get props => [message];
}
