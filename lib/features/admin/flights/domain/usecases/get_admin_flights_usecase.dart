import 'package:dartz/dartz.dart';
import 'package:travle/core/network/error_handler.dart';
import '../entities/admin_flights_entity.dart';
import '../repositories/admin_flights_repository.dart';

class GetAdminFlightsUseCase {
  final AdminFlightsRepository repository;

  const GetAdminFlightsUseCase(this.repository);

  Future<Either<Failure, AdminFlightsEntity>> call({
    DateTime? from,
    DateTime? to,
    String? tripType,
    String? category,
  }) async {
    return await repository.getFlights(
      from: from,
      to: to,
      tripType: tripType,
      category: category,
    );
  }
}
