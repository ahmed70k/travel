import '../entities/admin_overview_entity.dart';
import '../repositories/admin_repository.dart';

class GetAdminOverviewUseCase {
  final AdminRepository repository;

  GetAdminOverviewUseCase(this.repository);

  Future<AdminOverviewEntity> call({DateTime? from, DateTime? to}) async {
    return await repository.getOverview(from: from, to: to);
  }
}
