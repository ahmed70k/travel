import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/admin_users_entity.dart';
import '../repositories/admin_users_repository.dart';

class GetAdminUsersUseCase {
  final AdminUsersRepository repository;

  GetAdminUsersUseCase(this.repository);

  Future<Either<Failure, UsersResponseDataEntity>> call({
    int page = 1,
    int limit = 10,
    String? query,
    String? role,
    String? status,
    String? sortBy,
    String? sortOrder,
  }) async {
    return await repository.getUsers(
      page: page,
      limit: limit,
      query: query,
      role: role,
      status: status,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
  }
}
