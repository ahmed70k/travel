import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../repositories/admin_users_repository.dart';

class DeleteUserUseCase {
  final AdminUsersRepository repository;

  DeleteUserUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteUser(id);
  }
}
