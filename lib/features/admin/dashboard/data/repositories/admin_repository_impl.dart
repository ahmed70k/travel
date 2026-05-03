import '../../domain/entities/admin_overview_entity.dart';
import '../../domain/repositories/admin_repository.dart';
import '../datasources/admin_remote_data_source.dart';
import 'package:intl/intl.dart';



class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource remoteDataSource;

  AdminRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AdminOverviewEntity> getOverview({
    DateTime? from,
    DateTime? to,
  }) async {
    final fromStr = from != null ? DateFormat('yyyy-MM-dd').format(from) : null;
    final toStr = to != null ? DateFormat('yyyy-MM-dd').format(to) : null;

    return await remoteDataSource.getAdminOverview(from: fromStr, to: toStr);
  }
}
