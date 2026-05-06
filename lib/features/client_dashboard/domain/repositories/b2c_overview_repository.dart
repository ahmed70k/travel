import '../entities/b2c_overview_entity.dart';

abstract class B2COverviewRepository {
  Future<B2COverviewEntity> getOverview({
    DateTime? from,
    DateTime? to,
  });
}
