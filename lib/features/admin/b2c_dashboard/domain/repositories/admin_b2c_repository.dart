import 'package:dartz/dartz.dart';
import 'package:travle/core/network/error_handler.dart';
import 'package:travle/features/admin/b2c_dashboard/domain/entities/admin_b2c_entity.dart';

abstract class AdminB2CRepository {
  Future<Either<Failure, AdminB2CEntity>> getDashboard({
    DateTime? from,
    DateTime? to,
  });
}
