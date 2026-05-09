import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/current_dashboard_entity.dart';

abstract class DashboardRepository {
  Future<Either<Failure, CurrentDashboardEntity>> getDashboardMe({DateTime? from, DateTime? to});
}
