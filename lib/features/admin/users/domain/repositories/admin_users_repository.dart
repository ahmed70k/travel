import 'package:dartz/dartz.dart';
import 'package:travle/core/network/error_handler.dart';
import '../entities/admin_users_entity.dart';

abstract class AdminUsersRepository {
  Future<Either<Failure, AdminUsersEntity>> getUsers({
    String? query,
    String? accountType,
    String? status,
  });
}
