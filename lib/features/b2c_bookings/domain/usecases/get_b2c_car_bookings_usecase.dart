import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/b2c_car_booking_entity.dart';
import '../repositories/b2c_bookings_repository.dart';

class GetB2CCarBookingsUseCase {
  final B2CBookingsRepository repository;

  GetB2CCarBookingsUseCase(this.repository);

  Future<Either<Failure, List<B2CCarBookingEntity>>> call() async {
    return await repository.getCarBookings();
  }
}
