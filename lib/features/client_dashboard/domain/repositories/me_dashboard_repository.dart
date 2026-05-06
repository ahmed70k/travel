import '../entities/me_dashboard_entity.dart';

abstract class MeDashboardRepository {
  Future<MeDashboardEntity> getMyDashboard({
    DateTime? from,
    DateTime? to,
  });
}
