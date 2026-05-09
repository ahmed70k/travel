import 'package:dartz/dartz.dart';
import '../../../../core/network/error_handler.dart';
import '../entities/availability_entity.dart';
import '../../data/repositories/cars_availability_repository_impl.dart';

class GetCarsAvailabilityUseCase {
  final CarsAvailabilityRepository repository;

  GetCarsAvailabilityUseCase(this.repository);

  Future<Either<Failure, AvailabilityEntity>> call({String? from, String? to}) {
    return repository.getAvailability(from: from, to: to);
  }
}
