import 'package:dartz/dartz.dart';
import '../../../../core/network/error_handler.dart';
import '../datasources/b2b_overview_remote_data_source.dart';
import '../../domain/entities/b2b_overview_entity.dart';
import '../../domain/repositories/b2b_overview_repository.dart';

class B2BOverviewRepositoryImpl implements B2BOverviewRepository {
  final B2BOverviewRemoteDataSource remoteDataSource;

  B2BOverviewRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, B2BOverviewEntity>> getOverview({
    DateTime? from,
    DateTime? to,
  }) async {
    try {
      final remoteData = await remoteDataSource.getOverview(from: from, to: to);
      return Right(remoteData);
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
