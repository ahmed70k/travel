import 'package:dartz/dartz.dart';
import '../../../../core/network/error_handler.dart';
import '../entities/availability_entity.dart';
import '../repositories/flights_availability_repository.dart';

class GetFlightsAvailabilityUseCase {
  final FlightsAvailabilityRepository repository;

  GetFlightsAvailabilityUseCase(this.repository);

  Future<Either<Failure, AvailabilityEntity>> call({String? from, String? to}) {
    return repository.getAvailability(from: from, to: to);
  }
}
