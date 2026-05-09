import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/b2c_flight_booking_entity.dart';
import '../repositories/b2c_bookings_repository.dart';

class CreateB2CFlightBookingUseCase {
  final B2CBookingsRepository repository;

  CreateB2CFlightBookingUseCase(this.repository);

  Future<Either<Failure, B2CFlightBookingEntity>> call(B2CFlightBookingEntity booking) async {
    return await repository.createFlightBooking(booking);
  }
}
