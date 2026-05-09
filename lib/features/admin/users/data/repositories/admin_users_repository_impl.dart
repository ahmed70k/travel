import 'package:dartz/dartz.dart';
import 'package:travle/core/error/failures.dart';
import 'package:travle/core/network/error_handler.dart';
import '../../domain/entities/admin_users_entity.dart';
import '../../domain/repositories/admin_users_repository.dart';
import '../datasources/admin_users_remote_data_source.dart';

class AdminUsersRepositoryImpl implements AdminUsersRepository {
  final AdminUsersRemoteDataSource remoteDataSource;

  AdminUsersRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, UsersResponseDataEntity>> getUsers({
    int page = 1,
    int limit = 10,
    String? query,
    String? role,
    String? status,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      final response = await remoteDataSource.getUsers(
        page: page,
        limit: limit,
        query: query,
        role: role,
        status: status,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );
      return Right(response);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, UserEntity>> createUser({
    required String name,
    required String email,
    required String password,
    required String role,
    required String status,
  }) async {
    try {
      final response = await remoteDataSource.createUser(
        name: name,
        email: email,
        password: password,
        role: role,
        status: status,
      );
      return Right(response);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUser({
    required String id,
    required String name,
    required String email,
    String? password,
    required String role,
    required String status,
  }) async {
    try {
      final response = await remoteDataSource.updateUser(
        id: id,
        name: name,
        email: email,
        password: password,
        role: role,
        status: status,
      );
      return Right(response);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(String id) async {
    try {
      await remoteDataSource.deleteUser(id);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
