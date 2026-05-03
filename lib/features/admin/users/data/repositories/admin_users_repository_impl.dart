import 'package:dartz/dartz.dart';
import 'package:travle/core/network/error_handler.dart';
import '../../domain/entities/admin_users_entity.dart';
import '../../domain/repositories/admin_users_repository.dart';
import '../datasources/admin_users_remote_data_source.dart';

class AdminUsersRepositoryImpl implements AdminUsersRepository {
  final AdminUsersRemoteDataSource remoteDataSource;

  const AdminUsersRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, AdminUsersEntity>> getUsers({
    String? query,
    String? accountType,
    String? status,
  }) async {
    try {
      final response = await remoteDataSource.getUsers(
        query: query,
        accountType: accountType,
        status: status,
      );
      return Right(response);
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
