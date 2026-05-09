import 'package:dartz/dartz.dart';
import '../../../../core/network/error_handler.dart';
import '../entities/b2b_overview_entity.dart';
import '../repositories/b2b_overview_repository.dart';

class GetB2BOverviewUseCase {
  final B2BOverviewRepository repository;

  GetB2BOverviewUseCase(this.repository);

  Future<Either<Failure, B2BOverviewEntity>> call({
    DateTime? from,
    DateTime? to,
  }) {
    return repository.getOverview(from: from, to: to);
  }
}
