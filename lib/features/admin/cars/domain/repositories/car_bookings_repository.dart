import 'package:dartz/dartz.dart';
import 'package:travle/core/error/failures.dart';
import 'package:travle/features/admin/cars/data/models/car_booking_model.dart';

abstract class CarBookingsRepository {
  Future<Either<Failure, CarBookingsResponseModel>> getCarBookings({
    int page = 1,
    int limit = 10,
    String? search,
    String? status,
    String sortBy = "pickupDate",
    String sortOrder = "desc",
  });
}
