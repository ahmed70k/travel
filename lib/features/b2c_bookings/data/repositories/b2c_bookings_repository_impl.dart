import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/error_handler.dart';
import '../../domain/entities/b2c_flight_booking_entity.dart';
import '../../domain/entities/b2c_hotel_booking_entity.dart';
import '../../domain/entities/b2c_car_booking_entity.dart';
import '../../domain/repositories/b2c_bookings_repository.dart';
import '../datasources/b2c_bookings_remote_data_source.dart';
import '../models/flight_booking_model.dart';
import '../models/hotel_booking_model.dart';
import '../models/car_booking_model.dart';

class B2CBookingsRepositoryImpl implements B2CBookingsRepository {
  final B2CBookingsRemoteDataSource remoteDataSource;

  B2CBookingsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<B2CFlightBookingEntity>>> getFlightBookings() async {
    try {
      final remoteBookings = await remoteDataSource.getFlightBookings();
      return Right(remoteBookings);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, B2CFlightBookingEntity>> createFlightBooking(B2CFlightBookingEntity booking) async {
    try {
      final model = B2CFlightBookingModel.fromEntity(booking);
      final remoteBooking = await remoteDataSource.createFlightBooking(model);
      return Right(remoteBooking);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<B2CHotelBookingEntity>>> getHotelBookings() async {
    try {
      final remoteBookings = await remoteDataSource.getHotelBookings();
      return Right(remoteBookings);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, B2CHotelBookingEntity>> createHotelBooking(B2CHotelBookingEntity booking) async {
    try {
      final model = B2CHotelBookingModel.fromEntity(booking);
      final remoteBooking = await remoteDataSource.createHotelBooking(model);
      return Right(remoteBooking);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<B2CCarBookingEntity>>> getCarBookings() async {
    try {
      final remoteBookings = await remoteDataSource.getCarBookings();
      return Right(remoteBookings);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, B2CCarBookingEntity>> createCarBooking(B2CCarBookingEntity booking) async {
    try {
      final model = B2CCarBookingModel.fromEntity(booking);
      final remoteBooking = await remoteDataSource.createCarBooking(model);
      return Right(remoteBooking);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
