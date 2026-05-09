import 'package:dartz/dartz.dart';
import '../../../../core/network/error_handler.dart';
import '../../domain/entities/current_dashboard_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasource/dashboard_remote_datasource.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, CurrentDashboardEntity>> getDashboardMe({DateTime? from, DateTime? to}) async {
    try {
      final result = await remoteDataSource.getDashboardMe(from: from, to: to);
      return Right(result.data);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
