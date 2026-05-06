import '../entities/me_dashboard_entity.dart';
import '../repositories/me_dashboard_repository.dart';

class GetMeDashboardUseCase {
  final MeDashboardRepository repository;

  GetMeDashboardUseCase(this.repository);

  Future<MeDashboardEntity> call({DateTime? from, DateTime? to}) async {
    return await repository.getMyDashboard(from: from, to: to);
  }
}
