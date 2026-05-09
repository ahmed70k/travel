import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/b2c_flight_booking_entity.dart';
import '../entities/b2c_hotel_booking_entity.dart';
import '../entities/b2c_car_booking_entity.dart';

abstract class B2CBookingsRepository {
  Future<Either<Failure, List<B2CFlightBookingEntity>>> getFlightBookings();
  Future<Either<Failure, B2CFlightBookingEntity>> createFlightBooking(B2CFlightBookingEntity booking);
  
  Future<Either<Failure, List<B2CHotelBookingEntity>>> getHotelBookings();
  Future<Either<Failure, B2CHotelBookingEntity>> createHotelBooking(B2CHotelBookingEntity booking);

  Future<Either<Failure, List<B2CCarBookingEntity>>> getCarBookings();
  Future<Either<Failure, B2CCarBookingEntity>> createCarBooking(B2CCarBookingEntity booking);
}
