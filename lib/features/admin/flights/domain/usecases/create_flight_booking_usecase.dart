import 'package:dartz/dartz.dart';
import '../../../../../core/network/error_handler.dart';
import '../entities/admin_flights_entity.dart';
import '../repositories/admin_flights_repository.dart';

class CreateFlightBookingUseCase {
  final AdminFlightsRepository repository;

  CreateFlightBookingUseCase(this.repository);

  Future<Either<Failure, FlightBookingEntity>> call(FlightBookingEntity booking) async {
    return await repository.createFlight(booking);
  }
}
