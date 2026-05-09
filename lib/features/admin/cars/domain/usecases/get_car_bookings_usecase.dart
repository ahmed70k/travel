import 'package:dartz/dartz.dart';
import 'package:travle/core/error/failures.dart';
import 'package:travle/features/admin/cars/data/models/car_booking_model.dart';
import 'package:travle/features/admin/cars/domain/repositories/car_bookings_repository.dart';

class GetCarBookingsUseCase {
  final CarBookingsRepository repository;

  const GetCarBookingsUseCase(this.repository);

  Future<Either<Failure, CarBookingsResponseModel>> call({
    int page = 1,
    int limit = 10,
    String? search,
    String? status,
    String sortBy = "pickupDate",
    String sortOrder = "desc",
  }) {
    return repository.getCarBookings(
      page: page,
      limit: limit,
      search: search,
      status: status,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
  }
}
