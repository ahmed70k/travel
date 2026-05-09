import 'package:dartz/dartz.dart';
import 'package:travle/core/error/failures.dart';
import '../entities/car_booking_entity.dart';

abstract class CarBookingRepository {
  Future<Either<Failure, CarBookingEntity>> createCarBooking(CarBookingEntity booking);
}
