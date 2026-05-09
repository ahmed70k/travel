import 'package:dartz/dartz.dart';
import '../../../../core/network/error_handler.dart';
import '../entities/availability_entity.dart';

abstract class FlightsAvailabilityRepository {
  Future<Either<Failure, AvailabilityEntity>> getAvailability({String? from, String? to});
}
