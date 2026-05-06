import 'package:intl/intl.dart';
import '../../domain/entities/me_dashboard_entity.dart';
import '../../domain/repositories/me_dashboard_repository.dart';
import '../datasources/me_dashboard_remote_data_source.dart';

class MeDashboardRepositoryImpl implements MeDashboardRepository {
  final MeDashboardRemoteDataSource remoteDataSource;

  MeDashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<MeDashboardEntity> getMyDashboard({
    DateTime? from,
    DateTime? to,
  }) async {
    final fromStr = from != null ? DateFormat('yyyy-MM-dd').format(from) : null;
    final toStr = to != null ? DateFormat('yyyy-MM-dd').format(to) : null;
    return await remoteDataSource.getMyDashboard(from: fromStr, to: toStr);
  }
}
