import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../datasources/car_bookings_remote_data_source.dart';
import '../models/car_booking_model.dart';
import '../../domain/repositories/car_bookings_repository.dart';

class CarBookingsRepositoryImpl implements CarBookingsRepository {
  final CarBookingsRemoteDataSource remoteDataSource;

  const CarBookingsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, CarBookingsResponseModel>> getCarBookings({
    int page = 1,
    int limit = 10,
    String? search,
    String? status,
    String sortBy = "pickupDate",
    String sortOrder = "desc",
  }) async {
    try {
      final result = await remoteDataSource.getCarBookings(
        page: page,
        limit: limit,
        search: search,
        status: status,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
