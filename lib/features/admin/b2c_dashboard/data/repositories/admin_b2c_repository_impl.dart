import 'package:dartz/dartz.dart';
import 'package:travle/core/network/error_handler.dart';
import 'package:travle/features/admin/b2c_dashboard/data/datasources/admin_b2c_remote_data_source.dart';
import 'package:travle/features/admin/b2c_dashboard/domain/entities/admin_b2c_entity.dart';
import 'package:travle/features/admin/b2c_dashboard/domain/repositories/admin_b2c_repository.dart';

class AdminB2CRepositoryImpl implements AdminB2CRepository {
  final AdminB2CRemoteDataSource remoteDataSource;

  const AdminB2CRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, AdminB2CEntity>> getDashboard({
    DateTime? from,
    DateTime? to,
  }) async {
    try {
      final remoteDashboard = await remoteDataSource.getDashboard(from: from, to: to);
      return Right(remoteDashboard);
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
