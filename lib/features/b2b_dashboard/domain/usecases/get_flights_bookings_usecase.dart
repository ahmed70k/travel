import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/booking_entities.dart';
import '../repositories/bookings_repository.dart';

class GetB2BFlightsBookingsUseCase {
  final BookingsRepository repository;

  GetB2BFlightsBookingsUseCase({required this.repository});

  Future<Either<Failure, List<FlightBookingEntity>>> call() async {
    return await repository.getFlightsBookings();
  }
}
