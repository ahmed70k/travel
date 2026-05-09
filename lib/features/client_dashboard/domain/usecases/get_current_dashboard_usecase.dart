import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/current_dashboard_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetCurrentDashboardUseCase {
  final DashboardRepository repository;

  GetCurrentDashboardUseCase(this.repository);

  Future<Either<Failure, CurrentDashboardEntity>> call(DashboardParams params) async {
    return await repository.getDashboardMe(from: params.from, to: params.to);
  }
}

class DashboardParams extends Equatable {
  final DateTime? from;
  final DateTime? to;

  const DashboardParams({this.from, this.to});

  @override
  List<Object?> get props => [from, to];
}
