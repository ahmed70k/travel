import '../entities/admin_dashboard_entity.dart';
import '../repositories/admin_dashboard_repository.dart';

class GetAdminDashboardUseCase {
  final AdminDashboardRepository repository;

  GetAdminDashboardUseCase(this.repository);

  Future<AdminDashboardEntity> call({String? from, String? to}) async {
    return await repository.getMyDashboard(from: from, to: to);
  }
}
