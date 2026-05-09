import '../../data/datasources/admin_dashboard_remote_data_source.dart';
import '../../domain/entities/admin_dashboard_entity.dart';
import '../../domain/repositories/admin_dashboard_repository.dart';

class AdminDashboardRepositoryImpl implements AdminDashboardRepository {
  final AdminDashboardRemoteDataSource remoteDataSource;

  AdminDashboardRepositoryImpl(this.remoteDataSource);

  @override
  Future<AdminDashboardEntity> getMyDashboard({String? from, String? to}) async {
    return await remoteDataSource.getMyDashboard(from: from, to: to);
  }
}
