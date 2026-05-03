import '../entities/admin_overview_entity.dart';

abstract class AdminRepository {
  Future<AdminOverviewEntity> getOverview({DateTime? from, DateTime? to});
}
