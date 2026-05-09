import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';
import 'package:travle/core/network/error_handler.dart';
import '../../domain/entities/admin_flights_entity.dart';
import '../../domain/repositories/admin_flights_repository.dart';
import '../datasources/admin_flights_remote_data_source.dart';
import '../models/create_flight_booking_request.dart';

class AdminFlightsRepositoryImpl implements AdminFlightsRepository {
  final AdminFlightsRemoteDataSource remoteDataSource;

  const AdminFlightsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, AdminFlightsEntity>> getFlights({
    DateTime? from,
    DateTime? to,
    String? tripType,
    String? category,
  }) async {
    try {
      final response = await remoteDataSource.getFlights(
        from: from != null ? DateFormat('yyyy-MM-dd').format(from) : null,
        to: to != null ? DateFormat('yyyy-MM-dd').format(to) : null,
        tripType: tripType,
        category: category,
      );
      return Right(response);
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, FlightBookingEntity>> createFlight(FlightBookingEntity booking) async {
    try {
      final request = CreateFlightBookingRequest(
        id: booking.id,
        airline: booking.airline ?? '',
        flightNo: booking.flightNo ?? '',
        from: booking.from ?? '',
        to: booking.to ?? '',
        departureTime: booking.departureTime?.toIso8601String() ?? '',
        arrivalTime: booking.arrivalTime?.toIso8601String() ?? '',
        price: booking.price,
        status: booking.status,
        customer: booking.customer,
      );
      final response = await remoteDataSource.createFlight(request);
      return Right(response);
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
