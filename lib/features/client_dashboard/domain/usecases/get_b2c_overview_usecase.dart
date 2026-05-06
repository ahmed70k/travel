import '../entities/b2c_overview_entity.dart';
import '../repositories/b2c_overview_repository.dart';

class GetB2COverviewUseCase {
  final B2COverviewRepository repository;

  GetB2COverviewUseCase(this.repository);

  Future<B2COverviewEntity> call({DateTime? from, DateTime? to}) async {
    return await repository.getOverview(from: from, to: to);
  }
}
