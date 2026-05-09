import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/b2c_flight_booking_entity.dart';
import '../repositories/b2c_bookings_repository.dart';

class GetB2CFlightBookingsUseCase {
  final B2CBookingsRepository repository;

  GetB2CFlightBookingsUseCase(this.repository);

  Future<Either<Failure, List<B2CFlightBookingEntity>>> call() async {
    return await repository.getFlightBookings();
  }
}
