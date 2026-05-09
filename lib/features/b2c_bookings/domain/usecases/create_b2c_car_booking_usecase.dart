import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/b2c_car_booking_entity.dart';
import '../repositories/b2c_bookings_repository.dart';

class CreateB2CCarBookingUseCase {
  final B2CBookingsRepository repository;

  CreateB2CCarBookingUseCase(this.repository);

  Future<Either<Failure, B2CCarBookingEntity>> call(B2CCarBookingEntity booking) async {
    return await repository.createCarBooking(booking);
  }
}
