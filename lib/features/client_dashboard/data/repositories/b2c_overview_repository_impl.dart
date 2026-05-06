import 'package:intl/intl.dart';
import '../../domain/entities/b2c_overview_entity.dart';
import '../../domain/repositories/b2c_overview_repository.dart';
import '../datasources/b2c_remote_data_source.dart';

class B2COverviewRepositoryImpl implements B2COverviewRepository {
  final B2CRemoteDataSource remoteDataSource;

  B2COverviewRepositoryImpl({required this.remoteDataSource});

  @override
  Future<B2COverviewEntity> getOverview({
    DateTime? from,
    DateTime? to,
  }) async {
    final fromStr = from != null ? DateFormat('yyyy-MM-dd').format(from) : null;
    final toStr = to != null ? DateFormat('yyyy-MM-dd').format(to) : null;

    return await remoteDataSource.getB2COverview(from: fromStr, to: toStr);
  }
}
