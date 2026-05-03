import 'package:dartz/dartz.dart';
import 'package:travle/core/network/error_handler.dart';
import '../entities/admin_flights_entity.dart';

abstract class AdminFlightsRepository {
  Future<Either<Failure, AdminFlightsEntity>> getFlights({
    DateTime? from,
    DateTime? to,
    String? tripType,
    String? category,
  });
}
