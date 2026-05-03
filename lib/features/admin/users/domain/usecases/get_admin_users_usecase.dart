import 'package:dartz/dartz.dart';
import 'package:travle/core/network/error_handler.dart';
import '../entities/admin_users_entity.dart';
import '../repositories/admin_users_repository.dart';

class GetAdminUsersUseCase {
  final AdminUsersRepository repository;

  const GetAdminUsersUseCase(this.repository);

  Future<Either<Failure, AdminUsersEntity>> call({
    String? query,
    String? accountType,
    String? status,
  }) async {
    return await repository.getUsers(
      query: query,
      accountType: accountType,
      status: status,
    );
  }
}
