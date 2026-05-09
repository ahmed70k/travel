import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/booking_entities.dart';

abstract class BookingsRepository {
  Future<Either<Failure, MyBookingsEntity>> getMyBookings();
  
  // New GET methods
  Future<Either<Failure, List<FlightBookingEntity>>> getFlightsBookings();
  Future<Either<Failure, List<HotelBookingEntity>>> getHotelsBookings();
  Future<Either<Failure, List<CarBookingEntity>>> getCarsBookings();

  // New POST methods
  Future<Either<Failure, FlightBookingEntity>> createFlightBooking(FlightBookingEntity booking);
  Future<Either<Failure, HotelBookingEntity>> createHotelBooking(HotelBookingEntity booking);
  Future<Either<Failure, CarBookingEntity>> createCarBooking(CarBookingEntity booking);
}
