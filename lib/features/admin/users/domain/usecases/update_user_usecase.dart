import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/admin_users_entity.dart';
import '../repositories/admin_users_repository.dart';

class UpdateUserUseCase {
  final AdminUsersRepository repository;

  UpdateUserUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String id,
    required String name,
    required String email,
    String? password,
    required String role,
    required String status,
  }) async {
    return await repository.updateUser(
      id: id,
      name: name,
      email: email,
      password: password,
      role: role,
      status: status,
    );
  }
}
