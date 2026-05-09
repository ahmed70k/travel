import 'package:dartz/dartz.dart';
import 'package:travle/core/error/failures.dart';
import '../entities/car_booking_entity.dart';
import '../repositories/car_booking_repository.dart';

class CreateCarBookingUseCase {
  final CarBookingRepository repository;

  CreateCarBookingUseCase(this.repository);

  Future<Either<Failure, CarBookingEntity>> call(CarBookingEntity booking) async {
    return await repository.createCarBooking(booking);
  }
}
