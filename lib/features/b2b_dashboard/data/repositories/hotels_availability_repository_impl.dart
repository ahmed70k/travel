import 'package:dartz/dartz.dart';
import '../../../../core/network/error_handler.dart';
import '../../domain/entities/availability_entity.dart';
import '../datasources/hotels_availability_remote_data_source.dart';

abstract class HotelsAvailabilityRepository {
  Future<Either<Failure, AvailabilityEntity>> getAvailability({String? from, String? to});
}

class HotelsAvailabilityRepositoryImpl implements HotelsAvailabilityRepository {
  final HotelsAvailabilityRemoteDataSource remoteDataSource;

  HotelsAvailabilityRepositoryImpl({required this.remoteDataSource});

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
