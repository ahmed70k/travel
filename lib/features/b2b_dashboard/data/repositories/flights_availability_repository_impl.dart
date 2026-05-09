import 'package:dartz/dartz.dart';
import '../../../../core/network/error_handler.dart';
import '../../domain/entities/availability_entity.dart';
import '../../domain/repositories/flights_availability_repository.dart';
import '../datasources/flights_availability_remote_data_source.dart';

class FlightsAvailabilityRepositoryImpl implements FlightsAvailabilityRepository {
  final FlightsAvailabilityRemoteDataSource remoteDataSource;

  FlightsAvailabilityRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AvailabilityEntity>> getAvailability({String? from, String? to}) async {
    try {
      final result = await remoteDataSource.getAvailability(from: from, to: to);
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
