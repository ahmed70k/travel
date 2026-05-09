import 'package:dartz/dartz.dart';
import '../../../../core/network/error_handler.dart';
import '../entities/b2b_overview_entity.dart';

abstract class B2BOverviewRepository {
  Future<Either<Failure, B2BOverviewEntity>> getOverview({
    DateTime? from,
    DateTime? to,
  });
}
