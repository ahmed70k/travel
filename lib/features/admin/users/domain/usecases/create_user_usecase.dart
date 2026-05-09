import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/admin_users_entity.dart';
import '../repositories/admin_users_repository.dart';

class CreateUserUseCase {
  final AdminUsersRepository repository;

  CreateUserUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String name,
    required String email,
    required String password,
    required String role,
    required String status,
  }) async {
    return await repository.createUser(
      name: name,
      email: email,
      password: password,
      role: role,
      status: status,
    );
  }
}
