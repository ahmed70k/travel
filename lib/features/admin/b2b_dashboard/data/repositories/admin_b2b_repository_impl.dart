import 'package:dartz/dartz.dart';
import 'package:travle/core/network/error_handler.dart';
import 'package:travle/features/admin/b2b_dashboard/data/datasources/admin_b2b_remote_data_source.dart';
import 'package:travle/features/admin/b2b_dashboard/domain/entities/admin_b2b_entity.dart';
import 'package:travle/features/admin/b2b_dashboard/domain/repositories/admin_b2b_repository.dart';

class AdminB2BRepositoryImpl implements AdminB2BRepository {
  final AdminB2BRemoteDataSource remoteDataSource;

  const AdminB2BRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, AdminB2BEntity>> getDashboard({
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
