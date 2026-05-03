import 'package:dartz/dartz.dart';
import 'package:travle/features/admin/b2b_dashboard/domain/entities/admin_b2b_entity.dart';

import '../../../../../core/error/failures.dart';

abstract class AdminB2BRepository {
  Future<Either<Failure, AdminB2BEntity>> getDashboard({
    DateTime? from,
    DateTime? to,
  });
}
