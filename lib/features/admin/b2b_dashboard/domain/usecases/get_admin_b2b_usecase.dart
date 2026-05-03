import 'package:dartz/dartz.dart';
import 'package:travle/features/admin/b2b_dashboard/domain/entities/admin_b2b_entity.dart';
import 'package:travle/features/admin/b2b_dashboard/domain/repositories/admin_b2b_repository.dart';
import '../../../../../core/error/failures.dart';

class GetAdminB2BUseCase {
  final AdminB2BRepository repository;

  GetAdminB2BUseCase(this.repository);

  Future<Either<Failure, AdminB2BEntity>> call({
    DateTime? from,
    DateTime? to,
  }) async {
    return await repository.getDashboard(from: from, to: to);
  }
}
