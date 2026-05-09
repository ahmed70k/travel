import '../entities/admin_dashboard_entity.dart';

abstract class AdminDashboardRepository {
  Future<AdminDashboardEntity> getMyDashboard({String? from, String? to});
}
