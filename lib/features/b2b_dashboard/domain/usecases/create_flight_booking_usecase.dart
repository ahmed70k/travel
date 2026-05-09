import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/booking_entities.dart';
import '../repositories/bookings_repository.dart';

class CreateB2BFlightBookingUseCase {
  final BookingsRepository repository;

  CreateB2BFlightBookingUseCase({required this.repository});

  Future<Either<Failure, FlightBookingEntity>> call(FlightBookingEntity booking) async {
    return await repository.createFlightBooking(booking);
  }
}
